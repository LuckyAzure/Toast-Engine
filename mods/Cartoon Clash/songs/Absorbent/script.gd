extends Node

var events = [
	[17280, [["zoom_in",0.5]]]
]

var Back
var Timeline

func _ready():
	var path = get_script().get_path().get_base_dir() + "/events.json" 
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	events = JSON.parse_string(json_text)
	
	Back = get_parent().get_node("Background")
	Timeline = get_parent().get_node("HUD/Chart/Timeline")
	
	Back.get_node("Characters").character_nodes[0].modulate = Color.html("#BEBEBE")
	Back.get_node("Characters").character_nodes[1].modulate = Color.html("#BEBEBE")
	Back.get_node("Characters").character_nodes[2].modulate = Color.html("#BEBEBE")
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	
	create_black_bars()

func create_black_bars():
	var blackbars = [
		[Vector2(-640, -360), Vector2(1280, 100)],
		[Vector2(-640, 360 - 100), Vector2(1280, 100)],
	]

	var group = Marker2D.new()
	
	group.z_index = -1
	for i in blackbars.size():
		var blackbar = ColorRect.new()
		blackbar.position = blackbars[i][0]
		blackbar.size = blackbars[i][1]
		blackbar.color = Color(0, 0, 0)
		group.add_child(blackbar)
	
	Global.get_node_scene("HUD").add_child(group)


func _process(delta):
	dir_camera()

	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		for flag in events[0][1]:
			anim(flag)
		events.remove_at(0)

func anim(flag):
	match flag[0]:
		"setDefaultCameraZoom":
			Back.Offsets.Zoom = (flag[1].to_float() - 1)
		"black":
			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Stage").hide()
		"back":
			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 0)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 0)
			Back.get_node("Stage").show()

func dir_camera():
	if !Timeline.section.has("mustHitSection"):
		return
	var distance = 10.0
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

