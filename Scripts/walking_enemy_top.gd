# use one of these on a walking enemy, add the collision shape as a child of walking base
# in enemy, this will be used to emit the squish signal

extends Area2D

func _on_body_entered(body):
	if (body.is_in_group("player")):
		if (!body.is_on_floor()):
			get_parent().emit_signal("squish")
