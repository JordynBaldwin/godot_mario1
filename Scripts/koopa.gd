extends CharacterBody2D

const SPEED = 40.0
const ROLL_SPEED = 250.0

@onready var sprite = $AnimatedSprite2D
@onready var walking_enemy_base = $WalkingEnemyBase
@onready var death_timer = $DeathTimer
@onready var squishable_timer = $SquishableTimer

var dead = false

var states = {
	"wander" : 0,
	"shell" : 1,
	"shell_moving" : 2
}
var state = states["wander"]

signal touch
signal squish

func _ready():
	touch.connect(touched)
	squish.connect(squished)

func damagePlayer():
	get_tree().get_first_node_in_group("player").queue_free()

func touched():
	if (state == states["wander"]):
		damagePlayer()
	elif (state == states["shell"]):
		state = states["shell_moving"]
		if (get_tree().get_first_node_in_group("player").position.x < position.x):
			walking_enemy_base.direction = 1
		else:
			walking_enemy_base.direction = -1
	elif (state == states["shell_moving"]):
		damagePlayer()

func squished():
	if (state == states["shell"]):
		print("squish in shell state")
		touched()
	if (!squishable_timer):
		velocity.x = 0
		state = states["shell"]
	sprite.play("shell")

func death():
	dead = true
	velocity.x = 0
	walking_enemy_base.queue_free()
	sprite.play("dead")
	death_timer.start()
	
func _physics_process(delta: float) -> void:
	print (state)
	if (!dead):
		if not is_on_floor():
			velocity += get_gravity() * delta
		if (walking_enemy_base.direction):
			if (state == states["wander"]):
				velocity.x = walking_enemy_base.direction * SPEED
			if (state == states["shell_moving"]):
				velocity.x = walking_enemy_base.direction * ROLL_SPEED


	move_and_slide()


func _on_death_timer_timeout():
	queue_free()
