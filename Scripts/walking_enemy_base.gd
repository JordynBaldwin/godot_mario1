# use one of these on a walking enemy, add the collision shape as a child of walking base
# in enemy, this will be used to emit the touch signal

extends Area2D

var direction = -1
var raycastDamages = false

@onready var raycast_right = $RaycastRight
@onready var raycast_left = $RaycastLeft

func _on_body_entered(body):
	if (body.is_in_group("player")) || (body.is_in_group("enemy")):
		if (body.is_in_group("player") && body.velocity.y > 0):
			print(str(body) + " squish " + str(body.velocity.y))
			body.bounce()
			get_parent().walking_body_enter(body)
			get_parent().emit_signal("squish")
			
		else:
			print(str(body) + " touch " + str(body.velocity.y))
			get_parent().emit_signal("touch")
			
		
	
func _on_body_exited(body):
	get_parent().walking_body_exit(body)

func _process(delta):
	if raycast_right.is_colliding():
		var col = raycast_right.get_collider()
		if (col):
			if (raycastDamages) && (col.is_in_group("enemy")) || (col.is_in_group("player")):
				col.damage()
			else:
				direction = -1
				get_parent().sprite.flip_h = true
		
	if raycast_left.is_colliding():
		var col = raycast_left.get_collider()
		if (col):
			if (raycastDamages) && (col.is_in_group("enemy")) || (col.is_in_group("player")):
				col.damage()
			else:
				direction = 1
				get_parent().sprite.flip_h = false
	
