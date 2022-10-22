extends Node2D

# I'll finish it later, lol

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://src/Scenes/Menu/Menu.tscn")
