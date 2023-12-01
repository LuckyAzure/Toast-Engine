extends Node2D

var PORT = 4328
var MAX_CLIENTS = 2

func _ready():
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connect_failed)
	initalize_bg()

#------------------------------------------------------------------------

func initalize_bg():
	var image = Image.new()
	image.load("res://assets/images/Menu/background.png")
	$Background.texture = ImageTexture.create_from_image(image)

#------------------------------------------------------------------------

func _on_host_pressed():
	_host()

func _host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer

#------------------------------------------------------------------------

func _on_join_pressed():
	_join()

func _join():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client($CanvasLayer/IP.text, PORT)
	multiplayer.multiplayer_peer = peer

func _on_connected_ok():
	$Status.text = "CONNECTED"

func _on_connect_failed():
	$Status.text = "NOT WORKING IDIOT"
