extends Node2D

@onready var main_2d = $Main2D
var level_instance

func _ready():
	Global.main_scene = self
	loadLevel("test_screen")

func unloadLevel():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func loadLevel(levelName : String, spawnLocation = "Spawn"):
	unloadLevel()
	var level_path := "res://Scenes/Levels/%s.tscn" % levelName
	var level_resource := load(level_path)
	if (level_resource):
		# Disable warping for a tiny amount of time
		# (can likely remove when warping requires player input)
		Global.player.position = Vector2(-100.0, 100.0)
		
		level_instance = level_resource.instantiate()
		main_2d.add_child(level_instance)
		
		# Set player location to proper spawn
		var spawn_loc_path = "SpawnLocations/%s" % spawnLocation
		var spawn_node = level_instance.get_node(spawn_loc_path)
		Global.player.position = spawn_node.position
