extends Node2D

const option_spacing = 86.0

#------------------------------------------------------------------------

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	initalize_bg()
	initalize_options()
	create_options(null)

#------------------------------------------------------------------------

var main_bg = Texture

func initalize_bg():
	var image = Image.new()
	image.load("res://assets/images/Freeplay/bg.png")
	main_bg = ImageTexture.create_from_image(image)

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
			
			image.load(path + mod["bg_file"])
			mod["bg_file"] = ImageTexture.create_from_image(image)
			
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
		$Background.texture = main_bg
		category = null
		in_category = false
		for mod in preloaded_songs:
			load_options.append([mod.icon_file,mod.name])
	else:
		$Background.texture = preloaded_songs[data]["bg_file"]
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
	
	var target_color
	
	if in_category:
		target_color = Color.html(preloaded_songs[category]["freeplay"]["songs"][select][2])
	else:
		target_color = Color.html(preloaded_songs[select]["bg_color"])
	
	$Background.modulate = $Background.modulate.lerp(target_color,10.0 * delta)

#------------------------------------------------------------------------

var select = 0
var category = null

var in_category = false

func process_input():
	if Input.is_action_just_pressed("ui_up"):
		Sound.play("scroll")
		select -= 1
		if select < 0:
			select = nodes.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		Sound.play("scroll")
		select += 1
		if select > nodes.size() - 1:
			select = 0
	if Input.is_action_just_pressed("ui_accept"):
		Sound.play("confirm")
		if in_category:
			Global.state = {
				"song":{
					"name": preloaded_songs[category]["freeplay"]["songs"][select][1],
					"mod": Global.mods.mods[category - 1] if Global.mods.mods.size() > 0 else "Vanilla"
				},
				"mode":"freeplay",
				"select":select
			}
			if category == 0:
				Global.state.song.erase("mod")
			Overlay.change_scene_to_file("res://src/Scenes/Game/game.tscn","Fade")
		else:
			create_options(select)
			select = 0
	if Input.is_action_just_pressed("ui_cancel"):
		Sound.play("cancel")
		if in_category:
			select = category
			create_options(null)
		else:
			Sound.play("cancel")
			Overlay.state = "freeplay"
			Overlay.change_scene_to_file("res://src/Scenes/Menus/Main/Menu.tscn","Fade")

#------------------------------------------------------------------------
