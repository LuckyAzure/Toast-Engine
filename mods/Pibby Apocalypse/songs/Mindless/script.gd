extends Node

var events = [
    [121022.838583286, ["change_char_sword"]],
    [123308.552869001, ["change_char_slash"]],
    [125594.267154715, ["change_char_sword"]],
    [127879.981440429, ["change_char_slash"]],
    [130165.695726143, ["change_char_sword"]],
    [132451.410011858, ["change_char_slash"]],
    [134737.124297572, ["change_char_sword"]],
    [137022.838583286, ["change_char_slash"]],
    [139308.552869, ["change_char_sword"]],
    [141594.267154715, ["change_char_slash"]],
    [143879.981440429, ["change_char_sword"]],
    [146165.695726143, ["change_char_slash"]],
    [148451.410011857, ["change_char_sword"]],
    [150737.124297572, ["change_char_slash"]],
    [153022.838583286, ["change_char_sword"]],
    [155308.552869, ["change_char_slash"]],
    [157594.267154715, ["change_char_sword"]],
    [159879.981440429, ["change_char_slash"]],
    [164451.410011857, ["change_char_slash"]],
    [166737.124297572, ["change_char_sword"]],
    [169022.838583286, ["change_char_slash"]],
    [170879.981440429, ["change_char_sword"]],
    [173594.267154714, ["change_char_slash"]],
    [174737.124297571, ["change_char_sword"]],
    [184379.981440429, ["change_char_slash"]],
    [185022.838583286, ["change_char_sword"]],
    [193594.267154714, ["change_char_slash"]],
    [194165.695726143, ["change_char_sword"]],
    [202737.124297571, ["change_char_slash"]],
    [203308.552869, ["change_char_sword"]]
]

var Back = get_parent().get_node("Background")

func _ready():
	pass

func _process(_delta):
	dir_camera()

	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		for flag in events[0][1]:
			anim(flag)
		events.remove_at(0)


func anim(flag):
	match flag:
		"change_char_sword":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[0])
		"change_char_slash":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[1])


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

func custom_anim(data,charorder,type):
	var anim = def_animations[int(data[1]) % 4]
	if data[3] == "Dodge Note":
		Back.get_node("Characters").character_nodes[charorder].set_anim(anim + "_Alt")
		return
	Back.get_node("Characters").character_nodes[charorder].set_anim(anim)
