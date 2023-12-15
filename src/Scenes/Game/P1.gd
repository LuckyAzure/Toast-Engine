extends Marker2D

var animation_temp := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var animation := ["HUD_Idle", "HUD_Idle", "HUD_Idle", "HUD_Idle"]
var frames := [0.0, 0.0, 0.0, 0.0]

var note = preload("res://src/Scenes/Game/chart/note.tscn")
var noteorder = [[],[],[],[]]
var def_notes := ["Left", "Down", "Up", "Right"]
var input = [null,null,null,null]
var botplay = true

var offset = null

var status = {
	"hp":10000,
	"score": 0,
	"misses": 0,
	"accuracy": 0.0
}

var accuracy = {
	"min":0.0,
	"max":0.0
}

func HUD_TICK(delta: float) -> void:
	if !botplay:
		if accuracy.max > 0.0 and accuracy.min > 0.0:
			status.accuracy = accuracy.min / accuracy.max
		status.hp = clamp(status.hp,0.0,20000.0)
	
	var data = get_parent().data
	for i in range(def_notes.size()):
		if !botplay:
			if Input.is_key_pressed(input[i]):
				if animation[i] != "HUD_Glow":
					animation[i] = "HUD_Hold"
			else:
				animation[i] = "HUD_Idle"
		
		if animation[i] != animation_temp[i]:
			animation_temp[i] = animation[i]
			frames[i] = 0.0
		
		var maxframes = data[def_notes[i]][animation[i]]["texture"].size() - 1

		frames[i] += delta * 24.0
		frames[i] = clamp(frames[i], 0.0, maxframes)
		
		if botplay:
			if maxframes <= frames[i] and animation[i] == "HUD_Glow":
				animation[i] = "HUD_Idle"
				frames[i] = 0.0
				maxframes = data[def_notes[i]][animation[i]]["texture"].size() - 1
		
		get_node(def_notes[i]).texture = data[def_notes[i]][animation[i]]["texture"][int(frames[i])]

func spawn_note(data):
	var instance = note.instantiate()
	data[1] = int(data[1]) % 4
	
	get_node(def_notes[data[1]]).add_child(instance)
	instance.data = data
	instance.note_position = data[0]
	noteorder[data[1]].append(data[0])
	instance.note_data.bot = botplay
	instance.note_data.input = input[data[1]]
	instance.texture = get_parent().data[def_notes[data[1]]]["Note"]["texture"][0]
	instance.get_node("Sustain").texture = get_parent().data[def_notes[data[1]]]["Note_Long"]["texture"][0]
	instance.get_node("Sustain/End").texture = get_parent().data[def_notes[data[1]]]["Note_Long_End"]["texture"][0]

func notemiss(_order,_type):
	status.hp -= 750
	status.misses += 1
	
	accuracy.max += 350
	status.score -= 10

func notehit(_order,_distance,_type):
	var score = 0
	
	status.hp += 750
	if _distance < 40:
		score = 350
	elif _distance < 80:
		score = 200
	elif _distance < 120:
		score = 100
	else:
		score = 50
	
	status.score += score
	accuracy.min += score
	
	accuracy.max += 350
	
