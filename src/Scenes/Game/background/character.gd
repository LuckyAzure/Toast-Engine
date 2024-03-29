extends Marker2D

var char = null
var chardata = {}
var icon_texture = null

var fps = 24
var loop = false
var current_frame = 0
var frame_start_position = 0
var frame_max = 0
var remaining_frames = 0
var length = 0
var current_animation
var force = false

func _preload(data):
	chardata = data[0]
	$Texture.texture = data[1]
	
	scale = Vector2(chardata.scale,chardata.scale)
	$Texture.texture_filter = 0 if chardata.aa else 1
	$Texture.scale.x = -1 if chardata.flip_x else 1
	
	force = false
	set_anim(current_animation,false)
	Global.get_node_scene("HUD/Status").reload_icons()

func _load():
	var json_path = Global.get_mod_path(char) + "characters/" + char.name + "/" + char.name + ".json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	chardata = JSON.parse_string(file.get_as_text())
	file.close()
	
	# Load the image file from the specified path
	var image_path = Global.get_mod_path(char) + "characters/" + char.name + "/" + char.name + ".png"
	var image = Image.new()
	var image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		$Texture.texture = texture
	else:
		print("Failed to load image:", image_path)
	
	image_path = Global.get_mod_path(char) + "characters/" + char.name + "/icon.png"
	image = Image.new()
	image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		icon_texture = texture
	else:
		print("Failed to load image:", image_path)
	
	scale = Vector2(chardata.scale,chardata.scale)
	$Texture.texture_filter = 0 if chardata.aa else 1
	$Texture.scale.x = -1 if chardata.flip_x else 1
	
	force = false
	set_anim("Idle",false)

func _process(delta):
	animation(delta)

func animation(delta):
	if remaining_frames > 0.0:
		if current_frame < frame_start_position + frame_max:
			current_frame += delta * fps
		else:
			current_frame = frame_start_position + frame_max
		remaining_frames -= delta * fps
	if remaining_frames <= 0.0:
		if loop:
			current_frame = frame_start_position
			remaining_frames = length
		else:
			current_frame = frame_start_position + frame_max
		if current_animation != "Idle":
			force = false
			set_anim("Idle",false)
	
	var frame = chardata["xml_data"].TextureAtlas.frames[int(current_frame)]
	$Texture.region_rect = Rect2(frame.x, frame.y, frame.width, frame.height)

	if frame.has('frameX'):
		$Texture.offset = Vector2(
			-frame.frameX,
			-frame.frameY
		)

func set_anim(anim,force_anim = false, is_singing = false):
	if force_anim or !force:
		force = force_anim
		current_animation = anim
		if chardata.animations.has(anim):
			var anim_data = chardata.animations[anim]
			fps = anim_data.fps
			loop = anim_data.loop
			$Texture.position.x = anim_data.x
			$Texture.position.y = anim_data.y
			current_frame = anim_data.start_position
			frame_start_position = anim_data.start_position
			frame_max = anim_data.max
			remaining_frames = anim_data.length
			length = anim_data.length
