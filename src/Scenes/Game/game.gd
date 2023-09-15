extends Node2D

const input = [KEY_A, KEY_S, KEY_K, KEY_L]
var downscroll = true
var data

func _ready():
	var song_name = "Come-Along-With-Me"
	
	data = _load_data(song_name)
	_load_game(song_name)

func _load_data(song_name):
	var json_path = "res://assets/songs/" + song_name + "/song.json"
	return JSON.parse_string(FileAccess.open(json_path, FileAccess.READ).get_as_text())

func _load_game(song_name):
	var chartNotes = ["HUD/Chart/Notes/P1", "HUD/Chart/Notes/P2"]

	$Background._load(data.characters, data.stage)
	$HUD._load(song_name, "default")
	load_script(song_name)

	discord_sdk.details = "Playing: " + song_name
	discord_sdk.refresh()

	if downscroll:
		for note in chartNotes:
			get_node(note).position.y = -get_node(note).position.y

var has_script = false

func load_script(song_name):
	var song_path = "res://assets/songs/" + song_name + "/script.gd"
	if FileAccess.file_exists(song_path):
		has_script = true
		Global.get_node_scene("Script").set_script(load(song_path))
		$Script._ready()

func _process(delta):
	if has_script:
		$Script._process(delta)
