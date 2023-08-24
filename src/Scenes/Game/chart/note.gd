extends Sprite2D

var data = [0, 0, 0, 0]
var note_data = {
	"bot": true,
	"input": null
}

var song_speed = 1
var note_hittable = false
var note_holdable = false
var pressed = false
var note_position

var miss_cooldown = 0

func _ready():
	song_speed = get_tree().get_current_scene().song_speed
	position.y = (get_tree().get_current_scene().song_time - data[0]) * song_speed
	
	show()

func _process(delta):
	var time = get_tree().get_current_scene().song_time
	var is_sustain = false
	note_hittable = false
	
	if data[2] == 0:
		$Sustain.hide()
	else:
		is_sustain = true
	
	if note_data.bot:
		if (time - (note_position + data[2])) > 0:
			queue_free()
		if (time - note_position) <= 0:
			position.y = (time - note_position) * song_speed
			$Sustain.region_rect.size.y = (data[2] * song_speed) - 64
			$Sustain/End.position.y = (data[2] * song_speed) - 64
		else:
			position.y = 0
			self_modulate.a = 0
			$Sustain.region_rect.size.y = ((note_position + data[2] - time) * song_speed) - 64
			$Sustain/End.position.y = ((note_position + data[2] - time) * song_speed) - 64
	else:
		position.y = (time - note_position) * song_speed
		$Sustain.region_rect.size.y = (data[2] * song_speed) - 64
		$Sustain/End.position.y = (data[2] * song_speed) - 64
		var chart = get_tree().get_current_scene().chart
		if chart.NoteOrder[data[1]].size() > 0:
			var note_order_time = chart.NoteOrder[data[1]][0]
			if is_sustain:
				if (note_position + data[2]) - time > -150 and note_position - time <= 150 and note_order_time == data[0]:
					note_hittable = true
				elif (note_position + data[2]) < time - 150:
					queue_free()
					chart.NoteOrder[data[1]].pop_front()
				if data[2] < 75 and note_holdable and note_hittable and !Input.is_key_pressed(note_data.input):
					queue_free()
					chart.NoteOrder[data[1]].pop_front()
				if note_position < time - 150 and miss_cooldown <= 0:
					chart.notemiss(data[1])
					miss_cooldown = 3
				elif miss_cooldown > 0:
					print(miss_cooldown)
					miss_cooldown -= delta * 20
				if note_hittable and Input.is_key_pressed(note_data.input) and note_holdable:
					var diff = data[2] - (time - note_position)
					note_position = time
					data[2] = diff
					if data[2] < 0:
						queue_free()
						chart.NoteOrder[data[1]].pop_front()
			elif abs(note_position - time) <= 150 and note_order_time == data[0]:
				note_hittable = true
			elif note_position < time - 150:
				queue_free()
				chart.NoteOrder[data[1]].pop_front()
				chart.notemiss(data[1])
		

func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		return
	
	var time = get_tree().get_current_scene().song_time
	var chart = get_tree().get_current_scene().chart
	
	var just_pressed = event.is_pressed() and not event.is_echo()
	if data[2] == 0:
		if just_pressed and !note_data.bot and note_hittable and event.keycode == note_data.input:
			queue_free()
			chart.NoteOrder[data[1]].pop_front()
			get_parent().get_parent().animation[data[1]] = "HUD_Glow"
			chart.notehit(data[1],(time - data[0]))
	else:
		if just_pressed and !note_data.bot and note_hittable and event.keycode == note_data.input and !note_holdable:
			get_parent().get_parent().animation[data[1]] = "HUD_Glow"
			chart.notehit(data[1],(time - data[0]))
			self_modulate.a = 0
			note_holdable = true
