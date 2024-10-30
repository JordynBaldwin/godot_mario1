extends Area2D

@export var levelName : String

func _on_body_entered(body):
	if (body == Global.player):
		Global.main_scene.loadLevel(levelName)
