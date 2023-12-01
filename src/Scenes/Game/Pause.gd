extends CanvasLayer

const options = [
	"resume",
	"restart song",
	"exit to menu"
]

var cooldown = 0.5
var pause = false
var selected = false
var select = 0

#------------------------------------------------------------------------

var option_offset = 640.0
const option_spacing = 110.0

func scroll_options(delta):
	option_offset = lerp(option_offset, 283.0 - (select * option_spacing),10.0 * delta)

var nodes = []
var option_node = preload("res://src/Scenes/Game/pause/option.tscn")

func create_options():
	for option in options.size():
		var instance = option_node.instantiate()
		add_child(instance)
		nodes.append(instance)
		instance.data = {
			"text": options[option].to_upper(),
			"offset": option_spacing * option,
			"order": option
		}

func remove_options():
	for option in nodes:
		option.queue_free()
	nodes = []

#------------------------------------------------------------------------

func _ready():
	cooldown = 0.5

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
		return
	
	if pause:
		scroll_options(delta)
		$Back.show()
		if !selected:
			if Input.is_action_just_pressed("ui_accept"):
				Sound.play("scroll")
				match select:
					0:
						remove_options()
						get_tree().paused = false
						pause = false
					1:
						Overlay.change_scene_to_file("res://src/Scenes/Game/game.tscn","Fade")
						selected = true
						pass
					2:
						Global.end_song()
						selected = true
			if Input.is_action_just_pressed("ui_up"):
				Sound.play("scroll")
				select -= 1
				if select < 0:
					select = 2
			if Input.is_action_just_pressed("ui_down"):
				Sound.play("scroll")
				select += 1
				if select > 2:
					select = 0
	else:
		$Back.hide()
		if Input.is_action_just_pressed("ui_accept"):
			option_offset = 640.0
			create_options()
			select = 0
			get_tree().paused = true
			pause = true
