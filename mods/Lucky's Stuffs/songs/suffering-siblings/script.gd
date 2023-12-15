extends Node

var events = [
	[362558, ["finn_sword"]],
	[383773, ["black", "finn_slash"]],
	[413311, ["back", "finn_sword"]]
]

var Back = get_parent().get_node("Background")
var Timeline = get_parent().get_node("HUD/Chart/Timeline")

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0))

func _process(delta):
	dir_camera()

	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		for flag in events[0][1]:
			anim(flag)
		events.remove_at(0)

func anim(flag):
	match flag:
		"finn_sword":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[0])
		"finn_slash":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[1])
		"black":
aa			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Stage").hide()
		"back":
			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 0)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 0)
			Back.get_node("Stage").show()

func dir_camera():
	if !Timeline.section.has("mustHitSection"):
		return
	var distance = 25.0
	var char = Back.get_node("Characters").character_nodes[int(!Timeline.section.mustHitSection)]
	match char.current_animation:
		"Left":
			Back.Offsets.Position = Vector2(-distance, 0)
			Back.Offsets.Rotation_Degrees = -distance * 0.05
		"Down":
			Back.Offsets.Position = Vector2(0, distance)
			Back.Offsets.Rotation_Degrees = 0
		"Up":
			Back.Offsets.Position = Vector2(0, -distance)
			Back.Offsets.Rotation_Degrees = 0
		"Right":
			Back.Offsets.Position = Vector2(distance, 0)
			Back.Offsets.Rotation_Degrees = distance * 0.05
		_:
			Back.Offsets.Position = Vector2(0, 0)
			Back.Offsets.Rotation_Degrees = 0

