extends Node2D

#Stage Name
var stage_name = null

#Stage Datas
var stage_data = null

#Loads Stage Textures
func _load(stage):
	var main = Node2D.new()
	main.name = "Sprites"
	add_child(main)
	
	var parallaxes = []
	
	stage_name = stage.name
	
	var data_file = FileAccess.open(Global.get_mod_path(stage) + "Stages/" + stage_name + "/stage.json", FileAccess.READ)
	var data_json = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	stage_data = data_json
	for i in stage_data.sprites.size():
		var texture = Sprite2D.new()
		var data = stage_data.sprites[i]  # Rename the variable
		
		#default settings
		texture.centered = false
		
		texture.name = data.name
		
		texture.position = Vector2(data.pos[0], data.pos[1])
		texture.scale = Vector2(data.scale[0], data.scale[1])
		texture.z_index = data.index
		
		var image = Image.new()
		image.load(Global.get_mod_path(stage) + "stages/" + stage_name + "/" + data.texture.file)
		texture.texture = ImageTexture.create_from_image(image)
		
		texture.offset = Vector2(data.texture.offset[0], data.texture.offset[1])
		
		if data.has("flags"):
			for flag in data.flags:
				texture[flag[0]] = flag[1]
		
		if data.has("parallax"):
			var parallax_already_exist = false
			for p in parallaxes:
				if p[0] == data.parallax.layer:
					parallax_already_exist = true
					var parallax = ParallaxLayer.new()
					parallax.motion_scale = Vector2(data.parallax[0], data.parallax[1])
					p[1].add_child(parallax)
					parallax.add_child(texture)
			
			if !parallax_already_exist:
				var new_parallaxback = ParallaxBackground.new()
				new_parallaxback.layer = data.parallax.layer
				main.add_child(new_parallaxback)
				parallaxes.append([data.parallax.layer, new_parallaxback])
				
				var parallax = ParallaxLayer.new()
				parallax.motion_scale = Vector2(data.parallax.scale[0], data.parallax.scale[1])
				new_parallaxback.add_child(parallax)
				parallax.add_child(texture)
		else:
			main.add_child(texture)
	
	var script_path = Global.get_mod_path(stage) + "Stages/" + stage_name + "/script.gd"
	
	if FileAccess.file_exists(script_path):
		main.set_script(load(script_path))
