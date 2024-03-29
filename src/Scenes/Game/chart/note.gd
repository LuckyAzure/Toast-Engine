extends Sprite2D

var data = [0, 0, 0, 0]
var note_data = {
	"bot": true,
	"input": null
}

var backchars
var song_speed = 1
var note_hittable = false
var note_holdable = false
var pressed = false
var note_position

var sustain_end_texture_height
var sustain_anim_cooldown = 0
var miss_cooldown = 0
var downscroll = false

var remove = false

func _ready():
	backchars = Global.get_node_scene("Background/Characters")
	var chart_node = Global.get_node_scene("HUD/Chart")
	song_speed = chart_node.song_data.speed * 0.7
	position.y = (chart_node.song_time - data[0]) * song_speed
	downscroll = Global.scene().downscroll
	show()

func _process(delta):
	sustain_end_texture_height = $Sustain/End.texture.get_height()
	var time = Global.get_node_scene("HUD/Chart").song_time
	var section = get_parent().get_parent()
	var is_sustain = false
	note_hittable = false
	
	$Sustain.rotation_degrees = 180 if downscroll else 0
	
	if data[2] == 0:
		$Sustain.hide()
	else:
		is_sustain = true
	
	if note_data.bot:
		if (time - (note_position + data[2])) > 0:
			queue_free()
			backchars._set_anim(data,section.offset,null)
			section.animation[int(data[1]) % 4] = "HUD_Glow"
		if (time - note_position) <= 0:
			position.y = (note_position - time) * song_speed
			if downscroll:
				position.y = -position.y
			$Sustain.region_rect.size.y = (data[2] * song_speed) - sustain_end_texture_height
			$Sustain/End.position.y = (data[2] * song_speed) - sustain_end_texture_height
		else:
			position.y = 0
			self_modulate.a = 0
			if sustain_anim_cooldown <= 0:
				backchars._set_anim(data,section.offset,null)
				section.frames[data[1]] = 0
				sustain_anim_cooldown = 1
			else:
				sustain_anim_cooldown -= delta * 10
			section.animation[data[1]] = "HUD_Glow"
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
		var chart = Global.get_node_scene("HUD/Chart")
		var note_order = section.noteorder[data[1]]
		var note_order_size = note_order.size()

		if note_order_size > 0:
			var note_order_time = note_order[0]

			if is_sustain:
				var note_position_difference = note_position + data[2] - time

				if note_order_time == data[0] and note_position_difference > -150 and note_position - time <= 150:
					note_hittable = true
					
				if note_hittable and Input.is_key_pressed(note_data.input) and note_holdable:
					section.animation[data[1]] = "HUD_Glow"
					if sustain_anim_cooldown <= 0:
						backchars._set_anim(data,section.offset,null)
						section.frames[data[1]] = 0
						sustain_anim_cooldown = 1
					else:
						sustain_anim_cooldown -= delta * 10
					var diff = data[2] - (time - note_position)
					note_position = time
					data[2] = diff

					if data[2] < 0:
						remove = true
					
				elif note_position_difference < -150:
					remove = true

				if data[2] < 150 and note_holdable and note_hittable and !Input.is_key_pressed(note_data.input):
					remove = true

				if note_position < time - 150 and miss_cooldown <= 0:
					section.notemiss(data[1],data[3])
					backchars._set_anim(data,section.offset,"Miss")
					miss_cooldown = 3
				elif miss_cooldown > 0:
					miss_cooldown -= delta * 20
			
			elif abs(note_position - time) <= 150 and note_order_time == data[0]:
				note_hittable = true
			elif note_position < time - 150:
				remove = true
				section.notemiss(data[1],data[3])
				backchars._set_anim(data,section.offset,"Miss")
		if remove:
			queue_free()
			note_order.pop_front()
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
		

func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		return
	
	var chart = Global.get_node_scene("HUD/Chart")
	var section = get_parent().get_parent()
	var time = chart.song_time
	
	var just_pressed = event.is_pressed() and not event.is_echo()
	if data[2] == 0:
		if just_pressed and !note_data.bot and note_hittable and event.keycode == note_data.input:
			remove = true
			section.animation[data[1]] = "HUD_Glow"
			section.notehit(data[1],(time - data[0]),data[3])
			backchars._set_anim(data,section.offset,null)
	else:
		if just_pressed and !note_data.bot and note_hittable and event.keycode == note_data.input and !note_holdable:
			section.animation[data[1]] = "HUD_Glow"
			section.notehit(data[1],(time - data[0]),data[3])
			backchars._set_anim(data,section.offset,null)
			self_modulate.a = 0
			note_holdable = true
