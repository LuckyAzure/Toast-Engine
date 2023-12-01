extends Node2D

var server_ip = "localhost:5264"

func _ready():
	initalize_bg()

#------------------------------------------------------------------------

func initalize_bg():
	var image = Image.new()
	image.load("res://assets/images/Menu/background.png")
	$Background.texture = ImageTexture.create_from_image(image)
