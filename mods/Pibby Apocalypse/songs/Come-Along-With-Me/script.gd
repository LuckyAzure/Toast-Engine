extends Node

var events = [
	[52000,["transform"]],
	[510000,["poop"]]
]

var Back = get_parent().get_node("Background")

func _ready():
	Back.get_node("Characters").character_nodes[0].hide()
	#Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[0])

func _process(_delta):
	dir_camera()

	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		for flag in events[0][1]:
			anim(flag)
		events.remove_at(0)


func anim(flag):
	match flag:
		"transform":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[0])

func dir_camera():
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
