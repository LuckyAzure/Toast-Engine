extends Node2D

var song_name = "untold-loneliness"
var song_speed = 2
var note_skin = "default"

var input = [KEY_A,KEY_S,KEY_K,KEY_L]

func _ready():
	chart = get_node("HUD/Chart")
	discord_sdk.details = "Playing: " + song_name
	discord_sdk.refresh()

var song_time = 0
var chart
