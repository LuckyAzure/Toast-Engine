extends Marker2D

var animation_temp := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var animation := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var frames := [0.0, 0.0, 0.0, 0.0]

var def_notes := ["Left", "Down", "Up", "Right"]

func HUD_TICK(delta: float) -> void:
	var data = get_parent().data

	for i in range(def_notes.size()):
		if animation[i] != animation_temp[i]:
			animation_temp[i] = animation[i]
			frames[i] = 0.0

		var maxframes = data[def_notes[i % 4]][animation[i]]["texture"].size() - 1

		frames[i] += delta * 24.0
		frames[i] = min(frames[i], maxframes)

		if maxframes <= frames[i] and animation[i] == "HUD_Glow":
			animation[i] = "HUD_Idle"
			frames[i] = 0.0
			maxframes = data[def_notes[i % 4]][animation[i]]["texture"].size() - 1

		get_node(def_notes[i]).texture = data[def_notes[i % 4]][animation[i]]["texture"][int(frames[i])]
