extends Node2D

const option_spacing = 72.0

var select = 0
var options = [
	["online",null],
	["freeplay",null],
	["credits",null],
	["options",null]
]

#------------------------------------------------------------------------

func _ready():
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

var offset = 286.0

func scroll_options(delta):
	offset = lerp(offset, 283 - (select * option_spacing),10.0 * delta)

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

#------------------------------------------------------------------------

var text_pos = 0.0

func display_text(delta):
	text_pos += delta * 250
	var text_pos2 = int(text_pos) % 1280
	$Text.position.x = text_pos2
	$Text2.position.x = text_pos2 - 1280
	$Text2.text = $Text.text
