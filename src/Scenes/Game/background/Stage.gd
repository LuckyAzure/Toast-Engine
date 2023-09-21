extends Node

#Stage Name
var stage_name = null

#Stage Datas
var stage_data = null
var texture_data = null

var textureobjload = preload("res://src/Scenes/Game/background/StageTexture.tscn")

#Loads Stage Textures
func _load(stname):
	stage_name = stname.name
	
	var data_file = FileAccess.open(Global.get_mod_path(stname) + "Stages/" + stage_name + "/stage.json", FileAccess.READ)
	var data_json = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	stage_data = data_json
	for i in stage_data.Stage.StageTexture.size():
		var texture = textureobjload.instantiate()
		add_child(texture)
		var local_texture_data = stage_data.Stage.StageTexture[i]  # Rename the variable
		
		var image = Image.new()
		image.load(Global.get_mod_path(stname) + "stages/" + stage_name + "/" + local_texture_data.filename)
		var image_texture = ImageTexture.create_from_image(image)
		texture.texture = image_texture
		texture.name = local_texture_data.name
		
		texture.texture_data = local_texture_data
		#index
		texture.z_index = local_texture_data.index
		#becentered
		texture.centered = local_texture_data.becentered
		#x
		texture.position.x = local_texture_data.x
		texture.x = local_texture_data.x
		#y
		texture.position.y = local_texture_data.y
		texture.y = local_texture_data.y
		#width
		texture.scale.x = local_texture_data.width
		texture.sx = local_texture_data.width
		#height
		texture.scale.y = local_texture_data.height
		texture.sy = local_texture_data.height
