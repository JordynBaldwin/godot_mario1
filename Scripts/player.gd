extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
var g_mult = 1.0
var big_jump = false

func damage():
	queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0 and big_jump:
			if g_mult <= 1:
				velocity += get_gravity() * delta * g_mult
			else:
				velocity += get_gravity() * delta
			g_mult = g_mult * 1.5
		elif velocity.y == 0:
			velocity.y -= JUMP_VELOCITY * .2
		elif velocity.y < 900:
			velocity += get_gravity() * delta * 2.5
		elif velocity.y > 900:
			velocity.y = 900

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		g_mult = .3
		big_jump = true
	if Input.is_action_just_released("ui_accept"):
		big_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
