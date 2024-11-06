extends Area2D
# Make sure that any Area2D this script is on has the body enter signal conencted,
# level name set properly, and collision mask set to accept layer 5

@export_placeholder("Level name...") var levelName : String
@export_placeholder("Warp Node Name...") var spawnLocation = "Spawn"
@export_enum("enterPipeRight", "enterPipeLeft", "enterPipeUp", "enterPipeDown") var transitionAnimation : String
@export_enum("enterPipeRight", "enterPipeLeft", "enterPipeUp", "enterPipeDown") var transitionOutAnimation := "none"

@onready var time_till_load = $TimeTillLoad
var playerInZone = false
var canUseWarp = true

# Move player to proper position for pipe animation
func tweenPlayerAnimation():
	var tween = get_tree().create_tween()
	if (transitionAnimation == "enterPipeRight") || (transitionAnimation == "enterPipeLeft"):
			var playerXPos = Global.player.position.x
			tween.tween_property(Global.player, "position", Vector2(playerXPos, position.y - 2), 0.25)
	else:
		var playerYPos = Global.player.position.y
		tween.tween_property(Global.player, "position", Vector2(position.x, playerYPos), 0.25)
		
func warp():
	Global.audio_manager.stopSound()
	Global.audio_manager.sfx_pipe.play()
	canUseWarp = false
	Global.player.animation_player.play(transitionAnimation)
	Global.player.set_physics_process(false)
	
	tweenPlayerAnimation()
	
	time_till_load.start(Global.player.animation_player.current_animation_length)

func _on_body_entered(body):
	if (body == Global.player):
		playerInZone = true

func _on_body_exited(body):
	if (body == Global.player):
		playerInZone = false

func _process(delta):
	if (playerInZone && Global.player.is_on_floor() && canUseWarp):
		if (Input.is_action_pressed("ui_right") && transitionAnimation == "enterPipeRight"):
			warp()
		if (Input.is_action_pressed("ui_left") && transitionAnimation == "enterPipeLeft"):
			warp()
		if (Input.is_action_pressed("ui_up") && transitionAnimation == "enterPipeUp"):
			warp()
		if (Input.is_action_pressed("ui_down") && transitionAnimation == "enterPipeDown"):
			warp()

func _on_time_till_load_timeout():
	Global.main_scene.loadLevel(levelName, spawnLocation, transitionOutAnimation != "none")
	if (transitionOutAnimation != "none"):
		Global.player.animation_player.play_backwards(transitionOutAnimation)
		Global.player.activation_timer.start()
	else:
		Global.player.set_physics_process(true)
