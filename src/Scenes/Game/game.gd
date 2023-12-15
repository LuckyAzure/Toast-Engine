extends Node2D

var current_song

var downscroll
var is_multiplayer = false

var data
var start_from = 0
#380

var song

func _ready():
	downscroll = Save.data.options.gameplay.scroll
	song = Global.state.song
	
	data = _load_data(song)
	_load_game(song)

func _load_data(song):
	var json_path = Global.get_mod_path(song) + "songs/" + song.name + "/song.json"
	return JSON.parse_string(FileAccess.open(json_path, FileAccess.READ).get_as_text())

func _load_game(song):
	current_song = song

	$Background._load(data)
	$HUD._load(song, "default")
	load_script(song)

	if downscroll:
		for section in $HUD/Chart/Notes.sections:
			section.position.y = -section.position.y
		$HUD/Status/HUDText.position.y = -$HUD/Status/HUDText.position.y

var has_script = false

func load_script(song):
	var song_path = Global.get_mod_path(song) + "songs/" + song.name + "/script.gd"
	if FileAccess.file_exists(song_path):
		has_script = true
		
		var local = load(song_path)
		var script = FileAccess.open(song_path, FileAccess.READ).get_as_text()
		
		Global.get_node_scene("Script").set_script(local)
		$Script._ready()

func _process(delta):
	if has_script:
		$Script._process(delta)


func _on_script_script_changed():
	Global.get_node_scene("Script").script.reload(true)
