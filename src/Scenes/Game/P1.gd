extends Marker2D

var animation_temp := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var animation := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var frames := [0.0, 0.0, 0.0, 0.0]

var def_notes := ["Left", "Down", "Up", "Right"]

func HUD_TICK(delta: float) -> void:
	var input = get_tree().get_current_scene().input
	var data = get_parent().data
	
	for i in range(def_notes.size()):
		if Input.is_key_pressed(input[i]):
			if animation[i] != "HUD_Glow":
				animation[i] = "HUD_Hold"
		else:
			animation[i] = "HUD_Idle"
		
		if animation[i] != animation_temp[i]:
			animation_temp[i] = animation[i]
			frames[i] = 0.0
		
		var maxframes = data[def_notes[i % 4]][animation[i]]["texture"].size() - 1

		frames[i] += delta * 24.0
		frames[i] = clamp(frames[i], 0.0, maxframes)
		
		get_node(def_notes[i]).texture = data[def_notes[i % 4]][animation[i]]["texture"][int(frames[i])]
