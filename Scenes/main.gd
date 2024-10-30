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
	
func loadLevel(levelName : String):
	unloadLevel()
	var level_path := "res://Scenes/Levels/%s.tscn" % levelName
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instantiate()
		main_2d.add_child(level_instance)
