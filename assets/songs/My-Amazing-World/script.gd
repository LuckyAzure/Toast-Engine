extends Node

var timer = 0
var timer2 = 0
var time = 0

var Back = get_parent().get_node("Background")

func _ready():
	Back.get_node("Characters").create_char("cartoon_bf_Gun",Vector2(1000,350))
	Back.get_node("Characters").character_nodes[3].z_index -= 1

func _process(delta):
	timer2 += delta * 7.5
	timer += delta * 7.5 * abs(sin(timer2) )
	var camerathingy = Vector2(sin(timer) * 25,cos(timer) * 25)
	
	Back.Offsets.Position = camerathingy
	Back.Offsets.Rotation_Degrees = camerathingy.x * 0.01
	
	if time == 0 and Global.get_node_scene("HUD/Chart").song_time > 96000:
		time = 1
		Back.get_node("Characters").character_nodes[1].set_anim("Left_Alt")

	if time == 1 and Global.get_node_scene("HUD/Chart").song_time > 117600:
		time = 2
		var temp = Back.get_node("Characters").character_nodes[3]
		Back.get_node("Characters").character_nodes[3] = Back.get_node("Characters").character_nodes[0]
		Back.get_node("Characters").character_nodes[0] = temp
