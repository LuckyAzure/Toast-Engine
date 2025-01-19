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

const def_char = {
	"name": null,
	"playable":false,
	"cameraoffset": {"x":0,"y":0},
	"scale": 1.0,
	"aa": true,
	"flip_x": false,
	"animations": {},
	"xml_data": {},
	"hp_color": "#ffffff",
	"has_winning_icon": false
}

var charname = "boyfriend"
var chardata = {}
var xml_data
var animations = []
var current_animation = ""

var vanilla = true
var current_mod = "Vanilla"
var current_path = ""

func _ready():
	initalize_mods()
	for i in def_animations.size():
		$HUD/Animations.add_item(def_animations[i])
	load_char()

func initalize_mods():
	for mod in ["Vanilla"] + Global.mods.mods:
		var image_path = "res://mods/" + mod + "/icon32.png"
		if mod == "Vanilla":
			image_path = "res://assets/icon32.png"
		var image = Image.new()
		var image_loaded = image.load(image_path)
		$HUD/Mods.add_icon_item(ImageTexture.create_from_image(image),mod)

func load_char():
	chardata = {}
	
	if vanilla:
		current_path = "res://assets/"
	else:
		current_path = "res://mods/" + current_mod + "/"
	
	# Check if the JSON file exists
	var json_path = current_path + "characters/" + charname + "/" + charname + ".json"
	if not FileAccess.file_exists(json_path):
		create_default_json_file(json_path)
	else:
		var file = FileAccess.open(json_path, FileAccess.READ)
		chardata = JSON.parse_string(file.get_as_text())
		file.close()
	
	$HUD/Scale.value = chardata.scale
	$HUD/AA.button_pressed = chardata.aa
	$HUD/CameraX.value = chardata.cameraoffset.x
	$HUD/CameraY.value = chardata.cameraoffset.y
	if !chardata.has("hp_color"):
		chardata.merge({"hp_color": "#ffffff"},true)
	$HUD/HPBarColor.color = Color.html(chardata.hp_color)
	if !chardata.has("has_winning_icon"):
		chardata.merge({"has_winning_icon": false},true)
	if !chardata.has("playable"):
		chardata.merge({"playable": false},true)
	if !chardata.has("flip_x"):
		chardata.merge({"flip_x": false},true)
	$HUD/winning_icon.button_pressed = chardata.has_winning_icon
	$"HUD/Flip X".button_pressed = chardata.flip_x 
	$"HUD/Playable".button_pressed = chardata.playable 
	
	convert_xml_to_json_data()
	load_animations_from_data()
	load_animation("Idle")
	load_icon()

	# Load the image file from the specified path
	var image_path = current_path + "characters/" + charname + "/" + charname + ".png"
	var image = Image.new()
	var image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		$Char/Image.texture = texture
	else:
		print("Failed to load image:", image_path)

func create_default_json_file(json_path):
	print(json_path)
	chardata = def_char.duplicate(true)
	chardata["name"] = charname
	print(chardata)
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(chardata))
	file.close()

func save_char():
	chardata.scale = $HUD/Scale.value
	chardata.aa = $HUD/AA.button_pressed
	chardata.flip_x = $"HUD/Flip X".button_pressed
	chardata.playable = $"HUD/Playable".button_pressed
	chardata.cameraoffset.x = $HUD/CameraX.value
	chardata.cameraoffset.y = $HUD/CameraY.value
	chardata.hp_color = $HUD/HPBarColor.color.to_html()
	chardata.has_winning_icon = $HUD/winning_icon.button_pressed
	
	var json_path = current_path + "characters/" + charname + "/" + charname + ".json"
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(chardata))
	file.close()

var current_frame = 0
var frame_start_position = 0
var frame_max = 0
var remaining_frames = 0
var length = 0

func _process(delta):
	animation(delta)
	progress_bar()
	status()

func progress_bar():
	print(frame_max)
	length = $HUD/Length.value
	$HUD/ProgressBar.value = current_frame
	$HUD/ProgressBar.min_value = frame_start_position
	$HUD/ProgressBar.max_value = frame_start_position + frame_max
	$HUD/length_counter.text = "frames: " + str(int(current_frame - frame_start_position)) + "/" + str(int(frame_max))

func animation(delta):
	$Char.scale = Vector2($HUD/Scale.value,$HUD/Scale.value)
	$Char/Image.texture_filter = 0 if $HUD/AA.button_pressed else 1
	$Char/Image.scale.x = -1 if $"HUD/Flip X".button_pressed else 1
	var fps = $HUD/FPS.value
	var loop = $HUD/Loop.button_pressed

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
	
	var frame = chardata["xml_data"].TextureAtlas.frames[int(current_frame)]
	$Char/Image.region_rect = Rect2(frame.x, frame.y, frame.width, frame.height)

	if frame.has('frameX'):
		$Char/Image.offset = Vector2(
			-frame.frameX,
			-frame.frameY
		)


func status():
	var status = ""
	var sprite = $Char/Image.position
	status += "x: " + str(int(sprite.x)) + " | y: " + str(int(sprite.y))
	$HUD/Status.text = status
	$Line2D.position = Vector2(640,360) + Vector2($HUD/CameraX.value,$HUD/CameraY.value)

func convert_xml_to_json_data():
	var xml_parser = XMLParser.new()
	var f = FileAccess.open(current_path + "characters/" + charname + "/" + charname + ".xml", FileAccess.READ)
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
	chardata.xml_data = json_data

var animationnames = []

func load_animations_from_data():
	animationnames.clear()
	for i in chardata.xml_data.TextureAtlas.frames.size():
		#get name
		var framename = chardata.xml_data.TextureAtlas.frames[i].name
		framename = framename.erase(framename.length() - 4, 4)
		
		#check if its a new animation
		var alreadyexist = false
		for j in animationnames.size():
			if framename == animationnames[j][0]:
				animationnames[j][2] += 1
				alreadyexist = true
		if !alreadyexist:
			animationnames.append([framename,i,0])
	
	$HUD/CharAnimations.clear()
	for i in animationnames.size():
		$HUD/CharAnimations.add_item(animationnames[i][0])
	
	current_frame = animationnames[0][1]
	frame_start_position = animationnames[0][1]
	frame_max = animationnames[0][2]
	remaining_frames = animationnames[0][2]
	$HUD/Length.value = animationnames[0][2]

func _on_CharAnimations_item_selected(index):
	current_frame = animationnames[index][1]
	frame_start_position = animationnames[index][1]
	frame_max = animationnames[index][2]
	remaining_frames = animationnames[index][2]
	$HUD/Length.value = animationnames[index][2]

func save_animation(anim_name):
	var animation_name = anim_name
	var animation = {animation_name: 
		{
		"fps": $HUD/FPS.value,
		"loop": $HUD/Loop.button_pressed,
		"x": $Char/Image.position.x,
		"y": $Char/Image.position.y,
		"start_position": frame_start_position,
		"max": frame_max,
		"length": $HUD/Length.value
		}
	}
	
	# Assuming chardata.animations is a dictionary
	if not chardata.animations.has(animation_name):
		chardata.animations.merge({animation_name:{}})
	chardata.animations[animation_name] = animation[animation_name]  # Merge the nested dictionary directly

func load_animation(anim):
	current_animation = anim
	if chardata.animations.has(anim):
		var animation = chardata.animations[anim]
		$HUD/FPS.value = animation.fps
		$HUD/Loop.button_pressed = animation.loop
		$Char/Image.position.x = animation.x
		$Char/Image.position.y = animation.y
		if !animation.has("length"):
			animation["length"] = animation.max
		$HUD/Length.value = animation.length
		current_frame = animation.start_position
		frame_start_position = animation.start_position
		frame_max = animation.max
		remaining_frames = animation.length

func _on_mods_item_selected(index):
	if index == 0:
		vanilla = true
	else:
		vanilla = false
		current_mod = $HUD/Mods.get_item_text(index)

func load_icon():
	# Load the image file from the specified path
	var image_path = current_path + "characters/" + charname + "/icon.png"
	var image = Image.new()
	var image_loaded = image.load(image_path)

	if image_loaded == OK:
		var texture = ImageTexture.create_from_image(image)
		$HUD/Icon.texture = texture
		$HUD/Icon.region_rect = Rect2(0,0,texture.get_width() / (3 if chardata.has_winning_icon else 2),texture.get_height())
	else:
		print("Failed to load image:", image_path)


func _on_winning_icon_pressed():
	$HUD/Icon.region_rect = Rect2(0,0,$HUD/Icon.texture.get_width() / (3 if $HUD/winning_icon.button_pressed else 2),$HUD/Icon.texture.get_height())
