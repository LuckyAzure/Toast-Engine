extends Node2D

func _ready():
	Overlay.state = "Menu"
	# Menu Background Load (as an image)
	var BG = Image.new()
	BG.load("res://assets/images/menu/menuBG.png")
	var texture = ImageTexture.new()
	texture.create_from_image(BG)
	$Background.texture = texture
