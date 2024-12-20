extends CharacterBody2D

const MAX_WALK_SPEED = 300.0
const MAX_RUN_SPEED = 500.0
const ACCELERATION = 20.0
const JUMP_VELOCITY = -450.0
const MAX_FALL_SPEED = 900
const VALID_POWERS = ["small", "big", "flower"]
var g_mult = 1.0
var big_jump = false
var warping = false

var state = {
	"powerUp": "big",
	"facing": "right",
	"isJumping": false,
	"isRunning": false,
	"isInAir": false,
	"isStarPower": false
}

@onready var sprite = $AnimatedSprite2D
@onready var debug_label = $DebugLabel
@onready var collider = $Area2D
@onready var animation_player = $AnimationPlayer
@onready var activation_timer = $ActivationTimer

func _ready():
	Global.player = self
	collider.connect("area_entered", bounce)

func mario_die():
	set_physics_process(false)
	print("velocity on damage: " + str(velocity.y))
	sprite.play("die")
	Global.audio_manager.sfx_mariodie.play()
	collider.hide()

func damage():
	if state.powerUp == "small":
		mario_die()
	else:
		changeState("powerUp", "small")
		Global.audio_manager.sfx_pipe.play()

func bounce():
	velocity.y = JUMP_VELOCITY

func changeState(field, value):
	state[field] = value

func updateAnimation():
	# Verify correct facing
	if state.facing == "left":
		if not sprite.flip_h:
			sprite.flip_h = true
	elif sprite.flip_h:
		sprite.flip_h = false
	
	if state["powerUp"] in VALID_POWERS:
		if state.isInAir: # Always use jumping frame when in air
			sprite.play("jump_%s" % state["powerUp"])
		elif velocity.x == 0:
			sprite.play("stand_%s" % state["powerUp"])
		else:
			sprite.play("run_%s" % state["powerUp"])

func _process(delta):
	debug_label.text = str(int(velocity.y))
	debug_label.text += str('\nisJumping: ', state["isJumping"])
	debug_label.text += str('\ng_mult: ', g_mult)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if not state.isInAir: # Ensure isInAir is true while not on floor
			changeState("isInAir", true)
		if velocity.y < 0 and state.isJumping:
			velocity += get_gravity() * delta * g_mult
		elif velocity.y == 0:
			velocity.y -= JUMP_VELOCITY * .2
		elif velocity.y < MAX_FALL_SPEED:
			velocity += get_gravity() * delta
			if velocity.y > MAX_FALL_SPEED:
				velocity.y = MAX_FALL_SPEED
	elif state.isInAir: # Ensure isInAir is false while on floor
			changeState("isInAir", false)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			bounce()
			if state["powerUp"] == "small":
				Global.audio_manager.sfx_jump_small.play()
			else:
				Global.audio_manager.sfx_jump_super.play()
		changeState("isJumping", true)
		g_mult = .3
	if Input.is_action_just_released("ui_accept"):
		changeState("isJumping", false)
		g_mult = 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("ui_left"):
		changeState("facing", "left")
	if Input.is_action_just_pressed("ui_right"):
		changeState("facing", "right")
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction*MAX_WALK_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION/2)
	
	updateAnimation()
	
	move_and_slide()


func _on_activation_timer_timeout():
	set_physics_process(true)
