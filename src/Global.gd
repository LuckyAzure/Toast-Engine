extends Node

var mods = null
var state = {
	"song": {
		"name": "tutorial",
		"vanilla": true
	},
	"mode":"freeplay"
}

func _ready():
	var json_path = "res://mods/mods.json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	mods = JSON.parse_string(file.get_as_text())
	file.close()

func scene():
	return get_tree().get_current_scene()

func get_node_scene(node_path):
	return get_tree().get_current_scene().get_node(node_path)

func get_mod_path(data):
	var current_path
	if data.vanilla:
		current_path = "res://assets/"
	else:
		if data.mod != null:
			current_path = "res://mods/" + data.mod + "/"
		else:
			current_path = "res://mods/" + scene().current_song.mod + "/"
	return current_path

func start_song(song, mode = "freeplay"):
	state.song = song
	state.mode = mode
	Overlay.change_scene_to_file("res://src/Scenes/Game/game.tscn")

func end_song():
	match state.mode:
		"freeplay":
			Overlay.change_scene_to_file("res://src/Scenes/Menus/Freeplay/Freeplay.tscn")
