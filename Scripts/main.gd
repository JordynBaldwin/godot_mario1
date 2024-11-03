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
		
		# Set camera limits
		var cam_l_bound = getCamBound("left").x
		var cam_t_bound = getCamBound("top").y
		var cam_r_bound = getCamBound("right").x
		var cam_b_bound = getCamBound("bottom").y
		Global.camera.updateLimits(cam_l_bound, cam_t_bound, cam_r_bound, cam_b_bound)
