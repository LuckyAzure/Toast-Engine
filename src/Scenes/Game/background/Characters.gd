extends Node2D

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
	for char in data.characters:
		create_char(char)
	if data.has("preload_characters"):
		preload_chars(data.preload_characters)

func create_char(character):
	if character != null:
		var instance = char_node.instantiate()
		instance.char = character
		instance.position = Vector2(character.pos[0], character.pos[1])
		instance.z_index = character.index
		instance._load()
		add_child(instance)
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
		character_nodes[charorder].set_anim(anim,false)

func _on_timeline_beat_changed(beat):
	if beat % 2 == 0:
		for i in character_nodes.size():
			if character_nodes[i] != null:
				if character_nodes[i].current_animation == "Idle" and !character_nodes[i].loop:
					character_nodes[i].set_anim("Idle")
