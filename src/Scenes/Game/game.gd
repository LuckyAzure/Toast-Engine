extends Node2D

var song_name = "Suffering-Siblings"

var input = [KEY_A,KEY_S,KEY_K,KEY_L]

func _ready():
	discord_sdk.details = "Playing: " + song_name
	discord_sdk.refresh()
