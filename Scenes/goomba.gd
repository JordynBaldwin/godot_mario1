extends CharacterBody2D

const SPEED = 70.0

@onready var sprite = $sprite
@onready var walking_enemy_base = $WalkingEnemyBase

signal squish

func _ready():
	squish.connect(death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func death():
	sprite.play("dead")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if (walking_enemy_base.direction):
		velocity.x = walking_enemy_base.direction * SPEED


	move_and_slide()
