extends Node2D

@onready var main_2d = $Main2D
var level_instance
var camBounds = {
	"left" : 0,
	"right" : 544,
	"top" : 0,
	"bottom" : 416
}

func _ready():
	Global.main_scene = self
	loadLevel("test_screen")
	
func getCamBound(direction_name : String):
	var camera_limits_path = "CameraBoundaries/%s" % direction_name
	var camera_limits_node = level_instance.get_node(camera_limits_path)
	return camera_limits_node.position

func unloadLevel():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func loadLevel(levelName : String, spawnLocation = "Spawn"):
	unloadLevel()
	var level_path := "res://Scenes/Levels/%s.tscn" % levelName
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instantiate()
		main_2d.add_child(level_instance)
		
		# Set player location to proper spawn
		var spawn_loc_path = "SpawnLocations/%s" % spawnLocation
		var spawn_node = level_instance.get_node(spawn_loc_path)
		Global.player.position = spawn_node.position
		
		# Reset player animations
		Global.player.animation_player.play("RESET")
		
		# Set camera limits
		camBounds["left"] = getCamBound("left").x
		camBounds["top"] = getCamBound("top").y
		camBounds["right"] = getCamBound("right").x
		camBounds["bottom"] = getCamBound("bottom").y
		Global.camera.updateLimits(camBounds["left"], camBounds["top"], camBounds["right"], camBounds["bottom"])
