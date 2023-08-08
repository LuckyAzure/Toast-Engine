extends Node2D

const def_animations = [
	"Idle",
	"Left",
	"Down",
	"Up",
	"Right",
	"Left_Miss",
	"Down_Miss",
	"Up_Miss",
	"Right_Miss"
]

var charname = "LordXEncore"
var data
var animations = []
var xml_parser

func _ready():
	for i in def_animations.size():
		$HUD/Animations.add_item(def_animations[i])
	load_char()

func _on_Load_pressed():
	charname = $HUD/CharName.text
	load_char()

func load_char():
	convert_xml_to_json_data()
	load_animations_from_data()

	# Load the image file from the specified path
	var image_path = "res://assets/characters/" + charname + "/" + charname + ".png"
	var image = Image.new()
	var image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		$Char/Image.texture = texture
	else:
		print("Failed to load image:", image_path)

var current_frame = 0
var frame_start_position = 0
var frame_max = 0
var remaining_frames = 0

func _physics_process(delta):
	var frame = data.TextureAtlas.frames[int(current_frame)]
	$Char/Image.region_rect = Rect2(frame.x, frame.y, frame.width, frame.height)
	if frame.has('frameX'):
		$Char/Image.offset = Vector2(
			-frame.frameX,
			-frame.frameY
		)
	var fps = $HUD/SpinBox.value
	var loop = $HUD/Loop.button_pressed
	if remaining_frames > 0:
		current_frame += delta * fps
		remaining_frames -= delta * fps
	if remaining_frames <= 0 and loop:
		current_frame = frame_start_position
		remaining_frames = frame_max
	elif remaining_frames <= 0:
		current_frame = frame_start_position + frame_max - 1

func convert_xml_to_json_data():
	var xml_parser = XMLParser.new()
	var f = FileAccess.open("res://assets/characters/" + charname + "/" + charname + ".xml", FileAccess.READ)
	xml_parser.open_buffer(f.get_buffer(f.get_length()))
	f.close()

	var json_data = {
		"TextureAtlas": {
			"imagePath": "",
			"frames": []
		}
	}

	var frame_data = []

	while xml_parser.read() == OK:
		if xml_parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = xml_parser.get_node_name()
			if node_name == "SubTexture":
				var frame = {
					"name": xml_parser.get_named_attribute_value("name"),
					"x": xml_parser.get_named_attribute_value("x").to_float(),
					"y": xml_parser.get_named_attribute_value("y").to_float(),
					"width": xml_parser.get_named_attribute_value("width").to_float(),
					"height": xml_parser.get_named_attribute_value("height").to_float(),
					"frameX": xml_parser.get_named_attribute_value("frameX").to_float(),
					"frameY": xml_parser.get_named_attribute_value("frameY").to_float(),
					"frameWidth": xml_parser.get_named_attribute_value("frameWidth").to_float(),
					"frameHeight": xml_parser.get_named_attribute_value("frameHeight").to_float()
					# Add other attributes if needed
				}
				frame_data.append(frame)
			elif node_name == "TextureAtlas":
				json_data["TextureAtlas"]["imagePath"] = xml_parser.get_named_attribute_value("imagePath")

	json_data["TextureAtlas"]["frames"] = frame_data

	# Print the formatted JSON data
	data = json_data

var animationnames = []

func load_animations_from_data():
	animationnames.clear()
	for i in data.TextureAtlas.frames.size():
		#get name
		var framename = data.TextureAtlas.frames[i].name
		framename = framename.erase(framename.length() - 4, 4)
		
		#check if its a new animation
		var alreadyexist = false
		for j in animationnames.size():
			if framename == animationnames[j][0]:
				animationnames[j][2] += 1
				alreadyexist = true
		if !alreadyexist:
			animationnames.append([framename,i,1])
	
	$HUD/CharAnimations.clear()
	for i in animationnames.size():
		$HUD/CharAnimations.add_item(animationnames[i][0])
	
	current_frame = animationnames[0][1]
	frame_start_position = animationnames[0][1]
	frame_max = animationnames[0][2]
	remaining_frames = animationnames[0][2]

func _on_CharAnimations_item_selected(index):
	current_frame = animationnames[index][1]
	frame_start_position = animationnames[index][1]
	frame_max = animationnames[index][2]
	remaining_frames = animationnames[index][2]
