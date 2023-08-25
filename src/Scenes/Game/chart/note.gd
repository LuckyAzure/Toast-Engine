extends Sprite2D

enum NoteType { SINGLE, SUSTAIN }

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

var sustain_end_texture_height
var miss_cooldown = 0
var downscroll = false
var note_type = NoteType.SINGLE

func _ready():
	song_speed = get_tree().get_current_scene().song_speed
	position.y = (get_tree().get_current_scene().song_time - data[0]) * song_speed
	sustain_end_texture_height = $Sustain/End.texture.get_height()
	downscroll = get_tree().get_current_scene().downscroll
	show()

func _process(delta):
	sustain_end_texture_height = $Sustain/End.texture.get_height()
	var time = get_tree().get_current_scene().song_time
	var is_sustain = note_type == NoteType.SUSTAIN
	note_hittable = false
	
	$Sustain.rotation_degrees = 180 if downscroll else 0
	
	if data[2] == 0:
		$Sustain.hide()
	else:
		is_sustain = true
	
	if note_data.bot:
		if (time - (note_position + data[2])) > 0:
			queue_free()
		if (time - note_position) <= 0:
			position.y = (note_position - time) * song_speed
			if downscroll:
				position.y = -position.y
			$Sustain.region_rect.size.y = (data[2] * song_speed) - sustain_end_texture_height
			$Sustain/End.position.y = (data[2] * song_speed) - sustain_end_texture_height
		else:
			position.y = 0
			self_modulate.a = 0
			var sustain_size = ((note_position + data[2] - time) * song_speed) - sustain_end_texture_height
			$Sustain.region_rect.size.y = sustain_size
			$Sustain/End.position.y = sustain_size
			$Sustain/End.region_rect = Rect2(
				0,
				$Sustain/End.texture.get_height() - clamp(sustain_size, 0, $Sustain/End.texture.get_height()),
				$Sustain/End.texture.get_width(),
				clamp(sustain_size, 0.0, $Sustain/End.texture.get_height())
			)
	else:
		position.y = (note_position - time) * song_speed
		if downscroll:
			position.y = -position.y
		var sustain_size = (data[2] * song_speed) - sustain_end_texture_height
		$Sustain.region_rect.size.y = max(sustain_size, 0)
		$Sustain/End.position.y = sustain_size
		$Sustain/End.region_rect = Rect2(
			0,
			$Sustain/End.texture.get_height() - clamp(sustain_size, 0, $Sustain/End.texture.get_height()),
			$Sustain/End.texture.get_width(),
			clamp(sustain_size, 0.0, $Sustain/End.texture.get_height())
		)

		var chart = get_tree().get_current_scene().chart
		var note_order = chart.NoteOrder[data[1]]
		var note_order_size = note_order.size()

		if note_order_size > 0:
			var note_order_time = note_order[0]

			if is_sustain:
				var note_position_difference = note_position + data[2] - time

				if note_order_time == data[0] and note_position_difference > -150 and note_position - time <= 150:
					note_hittable = true
				elif note_position_difference < -150:
					queue_free()
					note_order.pop_front()

				if data[2] < 75 and note_holdable and note_hittable and !Input.is_key_pressed(note_data.input):
					queue_free()
					note_order.pop_front()

				if note_position < time - 150 and miss_cooldown <= 0:
					chart.notemiss(data[1])
					miss_cooldown = 3
				elif miss_cooldown > 0:
					miss_cooldown -= delta * 20

				if note_hittable and Input.is_key_pressed(note_data.input) and note_holdable:
					get_parent().get_parent().animation[data[1]] = "HUD_Glow"
					var diff = data[2] - (time - note_position)
					note_position = time
					data[2] = diff

					if data[2] < 0:
						queue_free()
						note_order.pop_front()
			elif abs(note_position - time) <= 150 and note_order_time == data[0]:
				note_hittable = true
			elif note_position < time - 150:
				queue_free()
				note_order.pop_front()
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
