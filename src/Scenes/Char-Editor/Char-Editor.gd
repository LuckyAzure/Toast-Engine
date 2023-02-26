extends Node2D

var charname = "LordXEncore"
var data

func _ready():
	load_char()

func _on_Load_pressed():
	charname = $HUD/CharName.text
	load_char()


func load_char():
	convert_xml_to_json_data()
	load_animations_from_data()
	# Texture Load (as an image)
	var image = Image.new()
	image.load("res://assets/characters/" + charname + "/" + charname + ".png")
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$Char/Image.texture = texture

var asd = 0
var framepos = 0
var framemax = 0
var frames = 0



func _physics_process(delta):
	var frame = data.TextureAtlas.frames[int(asd)]
	$Char/Image.region_rect = Rect2(frame.x,frame.y,frame.width,frame.height)
	if frame.has('frameX'):
		$Char/Image.offset = Vector2(
			-frame.frameX,
			-frame.frameY
		)
	asd += 0.5
	frames -= 0.5
	if 0 >= frames:
		asd = framepos
		frames = framemax

func convert_xml_to_json_data():
	var f = File.new()
	f.open("res://assets/characters/" + charname + "/" + charname + ".xml", File.READ)
	data = f.get_as_text()
	f.close()
	
	#start
	data = data.replace("	","")
	data = data.replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>","{")
	data = data.replace("<?xml version='1.0' encoding='utf-8'?>","{")
	data = data.replace("<TextureAtlas","	\"TextureAtlas\":\n	{\n")
	if "<!-- Created with Adobe Animate version " in data:
		data = data.replace(" imagePath=","		\"imagePath\": ")
		data = data.replace(">\n<!-- Created with Adobe Animate version ", ",\n		\"version\": \"")
		data = data.replace("<!-- http://www.adobe.com/products/animate.html -->\n","")
		data = data.replace(" -->", "\",\n		\"frames\":\n		[")
	else:
		data = data.replace(" imagePath=","		\"imagePath\": ")
		data = data.replace("\">\n<SubTexture ", "\",\n		\"frames\":\n		[\n			{")
	
	#frames parsing
	data = data.replace("<SubTexture ", "			{")
	
	#name
	data = data.replace("name=", "\"name\": ")
	
	#x
	data = data.replace("x=\"", ",\"x\": ")
	
	#y
	data = data.replace("\" y=\"", ", \"y\": ")
	
	#width
	data = data.replace("\" width=\"", ", \"width\": ")
	
	#height
	data = data.replace("\" height=\"", ", \"height\": ")
	
	#frameX
	data = data.replace("\" frameX=\"", ", \"frameX\": ")
	
	#frameY
	data = data.replace("\" frameY=\"", ", \"frameY\": ")
	
	#frameWidth
	data = data.replace("\" frameWidth=\"", ", \"frameWidth\": ")
	
	#frameHeight
	data = data.replace("\" frameHeight=\"", ", \"frameHeight\": ")
	
	#end
	data = data.replace("\"/>", "},")
	data = data.replace("\" />", "},")
	data = data.replace(",\n</TextureAtlas>", "\n		]\n	}\n}")
	
	data = parse_json(data)
	

var animationnames = []

func load_animations_from_data():
	animationnames.clear()
	for i in data.TextureAtlas.frames.size():
		#get name
		var framename = data.TextureAtlas.frames[i].name
		framename.erase(framename.length() - 4, 4)
		
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
	
	print(animationnames)
	

func _on_CharAnimations_item_selected(index):
	asd = animationnames[index][1]
	framepos = animationnames[index][1]
	framemax = animationnames[index][2]
	frames = animationnames[index][2]
