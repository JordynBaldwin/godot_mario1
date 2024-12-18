extends CharacterBody2D

const SPEED = 40.0
const ROLL_SPEED = 250.0

@onready var sprite = $AnimatedSprite2D
@onready var walking_enemy_base = $WalkingEnemyBase
@onready var death_timer = $DeathTimer
@onready var time_till_kickable = $TimeTillKickable
@onready var rekoop_timer = $RekoopTimer

# debug
@onready var debug_label = $DebugLabel

# end debug

var dead = false
var entered_bodies = []
var time_to_enter_rekoop_state = 5 # seconds
var time_to_play_rekoop_animation = 2 #seconds

var states = {
	"wander" : 0,
	"shell" : 1,
	"shell_moving" : 2,
	"rekoop" : 3
}
var state = states["wander"]

signal touch
signal squish

func _ready():
	sprite.flip_h = true
	touch.connect(touched)
	squish.connect(squished)
	
func walking_body_enter(body):
	entered_bodies.append(body)
	
func walking_body_exit(body):
	entered_bodies.erase(body)
	
func damage():
	queue_free()

func damagePlayer():
	get_tree().get_first_node_in_group("player").damage()
	
#region enter states

func enterWanderState():
	state = states["wander"]
	walking_enemy_base.raycastDamages = false
	sprite.play("walk")
	if (playerInArea()):
		damagePlayer()

func enterShellState():
	state = states["shell"]
	time_till_kickable.start()
	rekoop_timer.stop()
	rekoop_timer.start(time_to_enter_rekoop_state)
	velocity.x = 0
	walking_enemy_base.raycastDamages = false
	
func enterShellMovingState():
	state = states["shell_moving"]
	time_till_kickable.start()
	walking_enemy_base.raycastDamages = true
	sprite.play("shell")
	walking_enemy_base.direction = sign(position.x - get_tree().get_first_node_in_group("player").position.x)
	# use this instead if koopa shell should move in direction of player movement
	#walking_enemy_base.direction = sign(get_tree().get_first_node_in_group("player").velocity.x)
	rekoop_timer.stop()

func enterRekoopState():
	state = states["rekoop"]
	sprite.play("rekoop")
	rekoop_timer.start(time_to_play_rekoop_animation)

#endregion

func kicked():
	if (!time_till_kickable.time_left > 0):
		enterShellMovingState()

func touched():
	if (state == states["wander"]):
		damagePlayer()
	elif (state == states["shell"]):
		kicked()
	elif (state == states["shell_moving"]):
		damagePlayer()
	elif (state == states["rekoop"]):
		kicked()

func squished():
	if (state == states["shell"]):
		touched()
	else:
		enterShellState()
	sprite.play("shell")

func death():
	dead = true
	velocity.x = 0
	walking_enemy_base.queue_free()
	sprite.play("dead")
	death_timer.start()
	
func playerInArea():
	return entered_bodies.has(get_tree().get_first_node_in_group("player"))

func _physics_process(delta: float) -> void:
	if (!dead):
		if not is_on_floor():
			velocity += get_gravity() * delta
		if (walking_enemy_base.direction):
			if (state == states["wander"]):
				velocity.x = walking_enemy_base.direction * SPEED
			if (state == states["shell_moving"]):
				velocity.x = walking_enemy_base.direction * ROLL_SPEED

	move_and_slide()
	
func _process(delta):
	#debug_label.text = "state: " + str(state) + "\nraycastDamges: " + str(walking_enemy_base.raycastDamages)
	# player kicks shell if they start moving while still inside the shell
	if (playerInArea()):
		if (abs(get_tree().get_first_node_in_group("player").velocity.x) > 0.01):
			kicked()


func _on_death_timer_timeout():
	queue_free()


func _on_rekoop_timer_timeout():
	if (state != states["rekoop"]):
		enterRekoopState()
	else:
		enterWanderState()
