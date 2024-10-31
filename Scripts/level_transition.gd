extends Area2D
# Make sure that any Area2D this script is on has the body enter signal conencted,
# level name set properly, and collision mask set to accept layer 5

@export_placeholder("Level name...") var levelName : String
@export_placeholder("Warp Node Name...") var spawnLocation = "Spawn"

func _on_body_entered(body):
	if (body == Global.player):
		Global.main_scene.loadLevel(levelName, spawnLocation)
