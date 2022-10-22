extends Node2D

var menu_options = ["Story","Free","Online","Extras","Credits","Options","Exit"]
var select = 0

func _ready():
	# Menu Background Load (as an image)
	var BG = Image.new()
	BG.load("res://assets/images/menuBG.png")
	var texture = ImageTexture.new()
	texture.create_from_image(BG)
	$Background.texture = texture

func _process(delta):
	_Input() # Menu Controls
	
	# Smooth Option Vanishing
	for i in menu_options.size():
		if menu_options[select] != menu_options[i]:
			get_node(menu_options[i]).modulate.a = lerp(get_node(menu_options[i]).modulate.a,0.5,20 * delta)
		else:
			get_node(menu_options[select]).modulate.a = lerp(get_node(menu_options[select]).modulate.a,1,20 * delta)

func _Input():
	if Input.is_action_just_pressed("ui_up"):
		if select > 0:
			select -= 1
		else:
			select = menu_options.size() - 1
	if Input.is_action_just_pressed("ui_down"):
		if select < menu_options.size() - 1:
			select += 1
		else:
			select = 0
