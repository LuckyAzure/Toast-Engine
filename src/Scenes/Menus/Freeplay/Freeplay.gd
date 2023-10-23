extends Node2D

const option_spacing = 86.0

#------------------------------------------------------------------------

func _ready():
	initalize_options()
	create_options(null)

#------------------------------------------------------------------------

var preloaded_songs = []
var icons = []

func initalize_options():
	preloaded_songs = []
	
	for mod in ["Vanilla"] + Global.mods.mods:
		var path = "res://mods/" + mod + "/"
		if mod == "Vanilla":
			path = "res://assets/"
		if FileAccess.file_exists(path + "main.json"):
			var file = FileAccess.open(path + "main.json", FileAccess.READ)
			mod = JSON.parse_string(file.get_as_text())
			file.close()
			
			var image = Image.new()
			image.load(path + mod["icon_file"])
			mod["icon_file"] = ImageTexture.create_from_image(image)
			
			var icons = []
			for icon in mod["freeplay"]["icons"]:
				image.load(path + "Characters/" +  icon + "/icon.png")
				icon = ImageTexture.create_from_image(image)
				icons.append(icon)
			mod["freeplay"]["icons"] = icons
			preloaded_songs.append(mod)

#------------------------------------------------------------------------

var option_node = preload("res://src/Scenes/Menus/Freeplay/Option.tscn")
var nodes = []

func create_options(data):
	offset = 640.0
	for node in nodes:
		node.queue_free()
	nodes.clear()
	
	var load_options = []
	
	if data == null:
		category = null
		in_category = false
		for mod in preloaded_songs:
			load_options.append([mod.icon_file,mod.name])
	else:
		category = select
		in_category = true
		for song in preloaded_songs[data]["freeplay"]["songs"]:
			load_options.append([preloaded_songs[data]["freeplay"]["icons"][song[0]],song[1]])
	
	for option in load_options.size():
		var instance = option_node.instantiate()
		add_child(instance)
		instance.data = {
			"text": load_options[option][1].to_upper(),
			"offset": option_spacing * option,
			"order": option
		}
		instance.modulate.v = 0.5
		instance.get_node("Icon").texture = load_options[option][0]
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
