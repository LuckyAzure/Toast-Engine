extends Node

var timer = 0
var timer2 = 0
var time = 0

var Back = get_parent().get_node("Background")

func _ready():
	Back.get_node("Characters").character_nodes[0].hide()

func _process(delta):
	var distance = 50.0
	match Back.get_node("Characters").character_nodes[1].current_animation:
		"Left":
			Back.Offsets.Position = Vector2(-distance,0)
		"Down":
			Back.Offsets.Position = Vector2(0,distance)
		"Up":
			Back.Offsets.Position = Vector2(0,-distance)
		"Right":
			Back.Offsets.Position = Vector2(distance,0)
		_:
			Back.Offsets.Position = Vector2(0,0)
	match Back.get_node("Characters").character_nodes[1].current_animation:
		"Left":
			Back.Offsets.Rotation_Degrees = -distance * 0.05
		"Right":
			Back.Offsets.Rotation_Degrees = distance * 0.05
		_:
			Back.Offsets.Rotation_Degrees = 0
