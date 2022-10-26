extends Node2D

# I'll finish it later, lol

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Overlay.change_scene("res://src/Scenes/Menu/Menu.tscn",false,"Fade")

