extends Node

var mods = null 

func _ready():
	var json_path = "res://mods/mods.json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	mods = JSON.parse_string(file.get_as_text())
	print("haha")
	file.close()

func scene():
	return get_tree().get_current_scene()

func get_node_scene(node_path):
	return get_tree().get_current_scene().get_node(node_path)
