extends CharacterBody2D

const SPEED = 40.0

@onready var sprite = $AnimatedSprite2D
@onready var walking_enemy_base = $WalkingEnemyBase
@onready var death_timer = $DeathTimer
var dead = false

signal squish

func _ready():
	squish.connect(death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
