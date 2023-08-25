extends Node

var data
var note_skin
var note_path

func _process(delta):
	$P1.P1_HUD_TICK(delta)

func load_notes_texture():
	note_skin = get_tree().get_current_scene().note_skin
	note_path = "res://assets/notes/" + note_skin
	load_config(note_skin)
	replace_paths_to_preloaded_textures()

func load_config(note_name):
	#Check if the JSON file exists
	var json_path = "res://assets/notes/" + note_name + "/config.json"
	if not FileAccess.file_exists(json_path):
		print("not_found")
	else:
		var file = FileAccess.open(json_path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()

var def_notes = ["Left", "Down", "Up", "Right"]
var def_note_state = ["Note", "Note_Long", "Note_Long_End", "HUD_Idle", "HUD_Glow", "HUD_Hold", "HUD_Splash"]

func replace_paths_to_preloaded_textures():
	for type in def_notes:
		for state in def_note_state:
			for textures in data[type][state]["texture"].size():
				var path = note_path + "/" + data[type][state]["texture"][textures]
				
				var image = Image.new()
				var image_loaded = image.load(path)
				if image_loaded == OK:
					var texture = ImageTexture.create_from_image(image)
					data[type][state]["texture"][textures] = texture
				else:
					print(type + " of " + state + " not works.")
		#Now you can use the updated data dictionary to access textures for different note types and states
		#For example: data["Left"]["Note"]["texture"][0] will be a Texture object
	
		#Note: You can also assign the updated data dictionary to a member variable if needed.
