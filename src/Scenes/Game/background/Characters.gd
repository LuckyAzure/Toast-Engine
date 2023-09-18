extends Node

const def_animations = [
	"Left",
	"Down",
	"Up",
	"Right"
]

var char_node = preload("res://src/Scenes/Game/background/character.tscn")
var character_nodes = []
var preload_characters = []

func _load(data,stagedata):
	create_char(data.characters[0],Vector2(stagedata.Player.x,stagedata.Player.y))
	create_char(data.characters[1],Vector2(stagedata.Enemy.x,stagedata.Enemy.y))
	create_char(data.characters[2],Vector2(stagedata.GF.x,stagedata.GF.y))
	if data.has("preload_characters"):
		preload_chars(data.preload_characters)

func create_char(character,pos):
	if character != null:
		var instance = char_node.instantiate()
		add_child(instance)
		instance.char = character
		instance.position = pos
		instance._load()
		character_nodes.append(instance)
	else:
		character_nodes.append(null)

func preload_chars(data):
	for i in data.size():
		var char = data[i]
		i = [null,null,null]
		var json_path = Global.get_mod_path(char) + "characters/" + char.name + "/" + char.name + ".json"
		var file = FileAccess.open(json_path, FileAccess.READ)
		i[0] = JSON.parse_string(file.get_as_text())
		file.close()
		
		# Load the image file from the specified path
		var image_path = Global.get_mod_path(char) + "characters/" + char.name + "/" + char.name + ".png"
		var image = Image.new()
		var image_loaded = image.load(image_path)
		if image_loaded == OK:
			i[1] = ImageTexture.create_from_image(image)
		else:
			print("Failed to load image:", image_path)
		
		# Load the image file from the specified path
		image_path = Global.get_mod_path(char) + "characters/" + char.name + "/icon.png"
		image = Image.new()
		image_loaded = image.load(image_path)
		if image_loaded == OK:
			i[2] = ImageTexture.create_from_image(image)
		else:
			print("Failed to load image:", image_path)
		
		preload_characters.append(i)

func _set_anim(data,charorder,type):
	if character_nodes[charorder] != null:
		var anim = def_animations[int(data[1]) % 4]
		if type == "Miss":
			anim += "_Miss"
		if data[3] != null and Global.get_node_scene("Script").has_method("custom_anim"):
			Global.get_node_scene("Script").custom_anim(data,charorder,type)
			return
		character_nodes[charorder].set_anim(anim)

func _on_timeline_second_beat():
	for i in character_nodes.size():
		if character_nodes[i] != null:
			if character_nodes[i].current_animation == "Idle" and !character_nodes[i].loop:
				character_nodes[i].set_anim("Idle")
