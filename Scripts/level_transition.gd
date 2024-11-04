extends Area2D
# Make sure that any Area2D this script is on has the body enter signal conencted,
# level name set properly, and collision mask set to accept layer 5

@export_placeholder("Level name...") var levelName : String
@export_placeholder("Warp Node Name...") var spawnLocation = "Spawn"
@export_enum("enterPipeRight", "enterPipeLeft", "enterPipeUp", "enterPipeDown") var transitionAnimation : String

@onready var time_till_load = $TimeTillLoad

# Move player to proper position for pipe animation
func tweenPlayerAnimation():
	var tween = get_tree().create_tween()
	if (transitionAnimation == "enterPipeRight") || (transitionAnimation == "enterPipeLeft"):
			var playerXPos = Global.player.position.x
			tween.tween_property(Global.player, "position", Vector2(playerXPos, position.y - 2), 0.25)
	else:
		var playerYPos = Global.player.position.y
		tween.tween_property(Global.player, "position", Vector2(position.x, playerYPos), 0.25)
			
func _on_body_entered(body):
	if (body == Global.player):
		Global.player.animation_player.play(transitionAnimation)
		Global.player.set_physics_process(false)
		
		tweenPlayerAnimation()
		
		time_till_load.start(Global.player.animation_player.current_animation_length)


func _on_time_till_load_timeout():
	Global.main_scene.loadLevel(levelName, spawnLocation)
	Global.player.set_physics_process(true)
