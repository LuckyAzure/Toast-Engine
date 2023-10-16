extends Node2D

const option_spacing = 64.0

#------------------------------------------------------------------------

func _ready():
	initalize_options()
	create_options(null)

#------------------------------------------------------------------------

var preloaded_songs = []

func initalize_options():
	preloaded_songs = []
	
	var main_file = FileAccess.open("res://assets/main.json", FileAccess.READ)
	preloaded_songs.append(JSON.parse_string(main_file.get_as_text()))
	main_file.close()
	
	for mod in Global.mods.mods:
		var path = "res://mods/" + mod + "/main.json"
		if FileAccess.file_exists(path):
			var file = FileAccess.open(path, FileAccess.READ)
			mod = JSON.parse_string(file.get_as_text())
			file.close()
			preloaded_songs.append(mod)

#------------------------------------------------------------------------

var option_node = preload("res://src/Scenes/Menus/Freeplay/Option.tscn")
var nodes = []

func create_options(data):
	for node in nodes:
		node.queue_free()
	nodes.clear()
	
	var load_options = []
	
	if data == null:
		category = null
		in_category = false
		for mod in preloaded_songs:
			load_options.append(mod.name)
	else:
		category = select
		in_category = true
		for song in preloaded_songs[data]["freeplay"]["songs"]:
			load_options.append(song[1])
	
	for option in load_options.size():
		var instance = option_node.instantiate()
		add_child(instance)
		instance.data = {
			"text": load_options[option].to_upper(),
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
var category = null

var in_category = false

func process_input():
	if Input.is_action_just_pressed("ui_up"):
		select -= 1
		if select < 0:
			select = nodes.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		select += 1
		if select > nodes.size() - 1:
			select = 0
	if Input.is_action_just_pressed("ui_accept"):
		if in_category:
			Global.state = {
				"song":{
					"name": preloaded_songs[category]["freeplay"]["songs"][select][1],
					"vanilla": false if category != 0 else true,
					"mod": Global.mods.mods[category - 1]
				},
				"mode":"freeplay",
				"select":select
			}
			Overlay.change_scene_to_file("res://src/Scenes/Game/game.tscn","Fade")
		else:
			create_options(select)
			select = 0
	if Input.is_action_just_pressed("ui_cancel"):
		if in_category:
			select = category
			create_options(null)
		else:
			pass

#------------------------------------------------------------------------
