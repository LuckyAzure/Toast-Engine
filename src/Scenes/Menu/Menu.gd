extends Node2D

# Options (Node's name)
var menu_all_options = ["Story","Free","Online","Extras","Credits","Options","Exit"]
var menu_options = ["Free","Credits","Options"]

# Menu Choose Variables
var select = 0
var selected = false

func _ready():
	Overlay.state = "Menu"
	# Menu Background Load (as an image)
	var BG = Image.new()
	BG.load("res://assets/images/menu/menuBG.png")
	var texture = ImageTexture.new()
	texture.create_from_image(BG)
	$Background.texture = texture
	
	_reloadchar()

func _process(delta):
	if !selected:
		_Input() # Menu Controls
	
	_Animations(delta)

func _Input():
	if Input.is_action_just_pressed("ui_up"):
		$Char.position.y = 1200
		if select > 0:
			select -= 1
		else:
			select = menu_options.size() - 1
		_reloadchar()
	if Input.is_action_just_pressed("ui_down"):
		$Char.position.y = 1200
		if select < menu_options.size() - 1:
			select += 1
		else:
			select = 0
		_reloadchar()
	if Input.is_action_just_pressed("ui_accept"):
		Overlay.flash()
		selected = true
		get_node(menu_options[select]).rect_rotation = -360

func _Animations(delta):
	# Smooth Option Vanishing
	for i in menu_all_options.size():
		if menu_options[select] != menu_all_options[i]:
			if selected:
				get_node(menu_all_options[i]).modulate.a = lerp(get_node(menu_all_options[i]).modulate.a,0,20 * delta)
			else:
				get_node(menu_all_options[i]).modulate.a = lerp(get_node(menu_all_options[i]).modulate.a,0.5,20 * delta)
		else:
			get_node(menu_options[select]).modulate.a = lerp(get_node(menu_options[select]).modulate.a,1,20 * delta)
	if selected:
		get_node(menu_options[select]).rect_position.x = lerp(get_node(menu_options[select]).rect_position.x,50,10 * delta)
		get_node(menu_options[select]).rect_position.y = lerp(get_node(menu_options[select]).rect_position.y,320,10 * delta)
		get_node(menu_options[select]).rect_rotation = lerp(get_node(menu_options[select]).rect_rotation,0,10 * delta)
		$Design/Border.rect_position.x = lerp($Design/Border.rect_position.x,-360,10 * delta)
	$Char.position.y = lerp($Char.position.y,360,10 * delta)

func _reloadchar():
	var Char = Image.new()
	Char.load("res://assets/images/menu/" + menu_options[select] + ".png")
	var ctexture = ImageTexture.new()
	ctexture.create_from_image(Char)
	$Char.texture = ctexture
