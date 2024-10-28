extends CharacterBody2D

const SPEED = 40.0

@onready var sprite = $AnimatedSprite2D
@onready var walking_enemy_base = $WalkingEnemyBase
@onready var death_timer = $DeathTimer
var dead = false

signal touch
signal squish

func _ready():
	touch.connect(damagePlayer)
	squish.connect(death)
	
func walking_body_enter(body):
	pass
	
func walking_body_exit(body):
	pass
	
func damage():
	queue_free()

func damagePlayer():
	get_tree().get_first_node_in_group("player").damage()

func death():
	dead = true
	velocity.x = 0
	walking_enemy_base.queue_free()
	sprite.play("dead")
	death_timer.start()
	
func _physics_process(delta: float) -> void:
	if (!dead):
		if not is_on_floor():
			velocity += get_gravity() * delta
		if (walking_enemy_base.direction):
			velocity.x = walking_enemy_base.direction * SPEED


	move_and_slide()


func _on_death_timer_timeout():
	queue_free()
