extends Node2D

const option_spacing = 64.0

#------------------------------------------------------------------------

func _ready():
	create_options(null)

var option_node = preload("res://src/Scenes/Menus/Freeplay/Option.tscn")
var nodes = []

var category = null

func create_options(data):
	for node in nodes:
		node.queue_free()
	
	var options
	
	if data != null:
		print("whaa")
	else:
		options = Global.mods
	
	print(options)
	
	for option in options.mods.size():
		var instance = option_node.instantiate()
		add_child(instance)
		instance.data = {
			"text": options.mods[option].to_upper(),
			"offset": option_spacing * option,
			"order": option
		}
		nodes.append(instance)

#------------------------------------------------------------------------

func _process(delta):
	scroll_options(delta)
	process_input()

#------------------------------------------------------------------------

var offset = 283.0

func scroll_options(delta):
	offset = lerp(offset, 283 - (select * option_spacing), 10.0 * delta)

#------------------------------------------------------------------------

var select = 0

func process_input():
	if Input.is_action_just_pressed("ui_up"):
		select -= 1
		if select < 0:
			select = nodes.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		select += 1
		if select > nodes.size() - 1:
			select = 0

#------------------------------------------------------------------------
