extends Area2D

var direction = 1

@onready var raycast_right = $RaycastRight
@onready var raycast_left = $RaycastLeft

func _on_body_entered(body):
	if(body.is_in_group("player")):
		if (body.is_on_floor()):
			body.queue_free()
		else:
			get_parent().emit_signal("squish")
	
func _process(delta):
	if raycast_right.is_colliding():
		direction = -1
	if raycast_left.is_colliding():
		direction = 1
