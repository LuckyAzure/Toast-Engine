extends Node2D

const option_spacing = 72.0

var select = 0
var options = [
	["story mode",null],
	["freeplay","res://src/Scenes/Menus/Freeplay/Freeplay.tscn"],
	["online (lan)","res://src/Scenes/Online/lan_lobby.tscn"],
	["editors",null],
	["credits",null],
	["options","res://src/Scenes/Menus/Options/options.tscn"]
]

#------------------------------------------------------------------------

func _ready():
	for i in options.size():
		if Overlay.state == options[i][0]:
			select = i
	
	create_options()
	initalize_bg()

#------------------------------------------------------------------------

func initalize_bg():
	var image = Image.new()
	image.load("res://assets/images/Menu/background.png")
	$Background.texture = ImageTexture.create_from_image(image)
	image.load("res://assets/images/logo.png")
	$Logo.texture = ImageTexture.create_from_image(image)


#------------------------------------------------------------------------

var option_node = preload("res://src/Scenes/Menus/Main/Option.tscn")

func create_options():
	for option in options.size():
		var instance = option_node.instantiate()
		add_child(instance)
		instance.data = {
			"text": options[option][0].to_upper(),
			"offset": option_spacing * option,
			"order": option
		}

#------------------------------------------------------------------------

func _process(delta):
	scroll_options(delta)
	process_input()
	display_text(delta)

#------------------------------------------------------------------------

var offset = 640.0

func scroll_options(delta):
	offset = lerp(offset, 283.0 - (select * option_spacing),10.0 * delta)

#------------------------------------------------------------------------

func process_input():
	if Input.is_action_just_pressed("ui_up"):
		Sound.play("scroll")
		select -= 1
		if select < 0:
			select = options.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		Sound.play("scroll")
		select += 1
		if select > options.size() - 1:
			select = 0
	if Input.is_action_just_pressed("ui_accept"):
		Sound.play("confirm")
		if options[select][1] != null:
			Overlay.change_scene_to_file(options[select][1],"Fade")

#------------------------------------------------------------------------

var text_pos = 0.0

func display_text(delta):
	text_pos += delta * 250
	var text_pos2 = int(text_pos) % 1280
	$Text.position.x = text_pos2
	$Text2.position.x = text_pos2 - 1280
	$Text2.text = $Text.text
