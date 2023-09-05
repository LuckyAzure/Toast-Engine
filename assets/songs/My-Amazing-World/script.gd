extends Node

var timer = 0
var timer2 = 0
var laugh = false

var Back = get_parent().get_node("Background")

func _process(delta):
	timer2 += delta * 7.5
	timer += delta * 7.5 * abs(sin(timer2) )
	var camerathingy = Vector2(sin(timer) * 25,cos(timer) * 25)
	
	Back.Offsets.Position = camerathingy
	Back.Offsets.Rotation_Degrees = camerathingy.x * 0.01
	
	if !laugh and get_parent().song_time > 96000:
		laugh = true
		Back.get_node("Characters").character_nodes[1].set_anim("Left_Alt")
