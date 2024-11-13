extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if (body == Global.player):
		Global.audio_manager.sfx_bump.play()
		animation_player.play("bumped")
		
