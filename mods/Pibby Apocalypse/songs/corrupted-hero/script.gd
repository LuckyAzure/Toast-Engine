extends Node

var events = [
	[107184, ["zoom_in"]],
	[108349, ["black"]],
	[109514, ["set_pos"]],
	[118800, ["zoom1"]]
]

var Back = get_parent().get_node("Background")
var sounds = [null]

func _ready():
	RenderingServer.set_default_clear_color(Color(0,0,0))
	
	var audio = AudioStreamPlayer.new()
	audio.stream = AudioStreamOggVorbis.load_from_file(Global.get_mod_path(Global.scene().song) + "sounds/dodged.ogg")
	add_child(audio)
	sounds[0] = audio
	

var dir_cam = true

func _process(delta):
	if stage_vanish:
		if Back.get_node("Stage").modulate.a > 0:
			Back.get_node("Stage").modulate.a -= delta * 2.0
		else:
			Back.get_node("Stage").hide()
			Back.get_node("Stage").modulate.a = 1
			stage_vanish = false

	if dir_cam:
		dir_camera()

	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		for flag in events[0][1]:
			anim(flag)
		events.remove_at(0)


func anim(flag):
	match flag:
		"zoom_in":
			Back.scroll_speed = 0.2
			Back.Offsets.Zoom = 100.0
			Back.force_camera = true
			stage_vanish = true
			dir_cam = false
			print("hey")
		"black":
			Back.scroll_speed = 5
			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Characters").hide()
			Back.Position = Vector2(0,2000)
			Back.Offsets.Zoom = -0.5
		"set_pos":
			Back.Position = Vector2(300,300)
			Back.scroll.Zoom = 0.0
			Back.scroll.Position = Vector2(300,-4000)
			Back.get_node("Characters").show()
		"zoom1":
			Back.scroll_speed = 0.2
			Back.Offsets.Zoom = -0.1

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

const def_animations = [
	"Left",
	"Down",
	"Up",
	"Right"
]

var slash = false

func custom_anim(data,charorder,type):
	var anim = def_animations[int(data[1]) % 4]
	if data[3] == "Sword":
		Back.get_node("Characters").character_nodes[0].set_anim(anim + "_Alt",true)
		slash = !slash
		if slash:
			Back.get_node("Characters").character_nodes[1].set_anim("Left_Alt",true)
		else:
			Back.get_node("Characters").character_nodes[1].set_anim("Right_Alt",true)
		sounds[0].play(0)
		Back.scroll.Position.x = 0
		Back.scroll.Zoom = 0.75
		return
	Back.get_node("Characters").character_nodes[charorder].set_anim(anim,false)

var stage_vanish = false
