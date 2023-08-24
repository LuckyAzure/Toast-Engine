extends Sprite2D

var data = [0, 0, 0, 0]
var note_data = {
	"bot": true,
	"input": null
}

var song_speed = 1
var note_hittable = false
var pressed = false

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
		if (time - data[0]) <= 0:
			$Sustain.region_rect.size.y = data[2] * song_speed
			$Sustain/End.position.y = data[2] * song_speed
		else:
			$Sustain.region_rect.size.y = (data[0] + data[2] - time) * song_speed
			$Sustain/End.position.y = (data[0] + data[2] - time) * song_speed
	
	if note_data.bot:
		if (time - (data[0] + data[2])) > 0:
			queue_free()
		if (time - data[0]) <= 0:
			position.y = (time - data[0]) * song_speed
		else:
			position.y = 0
	else:
		position.y = (time - data[0]) * song_speed
		var chart = get_tree().get_current_scene().chart
		if chart.NoteOrder[data[1]].size() > 0:
			var note_order_time = chart.NoteOrder[data[1]][0]
			if abs(data[0] - time) <= 300 and note_order_time == data[0]:
				note_hittable = true
			elif data[0] < time - 300:
				queue_free()
				chart.notemiss(data[1])

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if just_pressed and !note_data.bot and note_hittable and event.keycode == note_data.input:
		queue_free()
		var chart = get_tree().get_current_scene().chart
		chart.notehit(data[1])
