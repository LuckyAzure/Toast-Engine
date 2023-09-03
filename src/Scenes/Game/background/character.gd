extends Marker2D

var charname = "finn-cn"
var chardata = {}

var fps = 24
var loop = false
var current_frame = 0
var frame_start_position = 0
var frame_max = 0
var remaining_frames = 0
var current_animation

func _load():
	var json_path = "res://assets/characters/" + charname + "/" + charname + ".json"
	var file = FileAccess.open(json_path, FileAccess.READ)
	chardata = JSON.parse_string(file.get_as_text())
	file.close()
	
	# Load the image file from the specified path
	var image_path = "res://assets/characters/" + charname + "/" + charname + ".png"
	var image = Image.new()
	var image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		$Texture.texture = texture
	else:
		print("Failed to load image:", image_path)
	
	scale = Vector2(chardata.scale,chardata.scale)
	$Texture.texture_filter = chardata.aa
	
	set_anim("Idle")

func _process(delta):
	animation(delta)

func animation(delta):
	if remaining_frames > 0.0:
		current_frame += delta * fps
		remaining_frames -= delta * fps
	if remaining_frames <= 0.0:
		if loop:
			current_frame = frame_start_position 
			remaining_frames = frame_max
		else:
			current_frame = frame_start_position + frame_max
		if current_animation != "Idle":
			set_anim("Idle")
	
	var frame = chardata["xml_data"].TextureAtlas.frames[int(current_frame)]
	$Texture.region_rect = Rect2(frame.x, frame.y, frame.width, frame.height)

	if frame.has('frameX'):
		$Texture.offset = Vector2(
			-frame.frameX,
			-frame.frameY
		)

func set_anim(anim):
	print(anim)
	current_animation = anim
	if chardata.animations.has(anim):
		var animation = chardata.animations[anim]
		fps = animation.fps
		loop = animation.loop
		$Texture.position.x = animation.x
		$Texture.position.y = animation.y
		current_frame = animation.start_position
		frame_start_position = animation.start_position
		frame_max = animation.max
		remaining_frames = animation.max
