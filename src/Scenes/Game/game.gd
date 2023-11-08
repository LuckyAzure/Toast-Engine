extends Node2D

var current_song

const input = [KEY_A, KEY_S, KEY_K, KEY_L]
var downscroll
var data
var start_from = 0
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
	var chartNotes = ["HUD/Chart/Notes/P1", "HUD/Chart/Notes/P2"]

	$Background._load(data)
	$HUD._load(song, "default")
	load_script(song)

	if downscroll:
		for note in chartNotes:
			get_node(note).position.y = -get_node(note).position.y
		$HUD/Status/HUDText.position.y = -$HUD/Status/HUDText.position.y

var has_script = false

func load_script(song):
	var song_path = Global.get_mod_path(song) + "songs/" + song.name + "/script.gd"
	if FileAccess.file_exists(song_path):
		has_script = true
		Global.get_node_scene("Script").set_script(load(song_path))
		$Script._ready()

func _process(delta):
	if has_script:
		$Script._process(delta)
