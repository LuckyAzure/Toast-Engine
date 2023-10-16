extends Node

# Event data with timestamps and corresponding actions
var events = [
	[107184, ["zoom_in"]],
	[108349, ["black"]],
	[109514, ["set_pos"]],
	[118800, ["zoom1"]]
]

# Reference to the "Background" node
var Back = get_parent().get_node("Background")
var Timeline = get_parent().get_node("HUD/Chart/Timeline")

# Array to store audio streams
var sounds = [null]

# Boolean flag to control camera direction
var dir_cam = true

# Function called when the node is ready
func _ready():
	# Set the default clear color for rendering
	RenderingServer.set_default_clear_color(Color(0, 0, 0))

	# Create an AudioStreamPlayer and load the audio file
	var audio = AudioStreamPlayer.new()
	audio.stream = AudioStreamOggVorbis.load_from_file(Global.get_mod_path(Global.scene().song) + "sounds/dodged.ogg")
	# Add the audio player as a child of this node
	add_child(audio)
	# Store the audio player in the sounds array
	sounds[0] = audio

# Function called every frame
func _process(delta):
	# Check if the stage should vanish
	if stage_vanish:
		# Reduce the alpha (transparency) of the stage modulate color
		if Back.get_node("Stage").modulate.a > 0:
			Back.get_node("Stage").modulate.a -= delta * 2.0
		else:
			# If the stage is fully transparent, hide it and reset alpha
			Back.get_node("Stage").hide()
			Back.get_node("Stage").modulate.a = 1
			# Reset the stage_vanish flag
			stage_vanish = false

	# Check camera direction flag
	if dir_cam:
		# Adjust camera direction based on character animation
		dir_camera()

	# Check if there are pending events and the current time matches the next event's timestamp
	if events.size() != 0 and Global.get_node_scene("HUD/Chart").song_time >= events[0][0]:
		# Iterate through the event types and perform corresponding actions
		for flag in events[0][1]:
			anim(flag)
		# Remove the processed event from the events list
		events.remove_at(0)

# Function to handle different animation events
func anim(flag):
	# Match the event type
	match flag:
		"zoom_in":
			# Handle zoom in event
			Back.scroll_speed = 0.2
			Back.Offsets.Zoom = 100.0
			Back.force_camera = true
			stage_vanish = true
			dir_cam = false
			print("hey")
		"black":
			# Handle black event
			Back.scroll_speed = 5
			# Set shader parameters to create a black effect
			Back.get_node("Characters").character_nodes[0].get_node("Texture").material.set_shader_parameter("mixture", 1)
			Back.get_node("Characters").character_nodes[1].get_node("Texture").material.set_shader_parameter("mixture", 1)
			# Hide character nodes and reposition the background
			Back.get_node("Characters").hide()
			Back.Position = Vector2(0, 2000)
			Back.Offsets.Zoom = -0.5
		"set_pos":
			# Handle set position event
			Back.Position = Vector2(300, 300)
			Back.scroll.Zoom = 0.0
			Back.scroll.Position = Vector2(300, -4000)
			Back.get_node("Characters").show()
		"zoom1":
			# Handle zoom1 event
			Back.scroll_speed = 0.2
			Back.Offsets.Zoom = -0.1

# Function to handle camera direction based on character animation
func dir_camera():
	if !Timeline.section.has("mustHitSection"):
		return
	var distance = 50.0
	var char = Back.get_node("Characters").character_nodes[int(!Timeline.section.mustHitSection)]
	# Determine character's current animation and adjust camera position and rotation
	match char.current_animation:
		"Left":
			Back.Offsets.Position = Vector2(-distance, 0)
			Back.Offsets.Rotation_Degrees = -distance * 0.05
		"Down":
			Back.Offsets.Position = Vector2(0, distance)
			Back.Offsets.Rotation_Degrees = 0
		"Up":
			Back.Offsets.Position = Vector2(0, -distance)
			Back.Offsets.Rotation_Degrees = 0
		"Right":
			Back.Offsets.Position = Vector2(distance, 0)
			Back.Offsets.Rotation_Degrees = distance * 0.05
		_:
			Back.Offsets.Position = Vector2(0, 0)
			Back.Offsets.Rotation_Degrees = 0

# Constant array representing default character animations
const def_animations = [
	"Left",
	"Down",
	"Up",
	"Right"
]

# Boolean flag to control alternating animations
var slash = false

# Function to handle custom animations
func custom_anim(data, charorder, type):
	var anim = def_animations[int(data[1]) % 4]
	# Check animation type and set corresponding animations for characters
	if data[3] == "Sword":
		Back.get_node("Characters").character_nodes[0].set_anim(anim + "_Alt", true)
		slash = !slash
		# Alternate between left and right animations for the second character
		if slash:
			Back.get_node("Characters").character_nodes[1].set_anim("Left_Alt", true)
		else:
			Back.get_node("Characters").character_nodes[1].set_anim("Right_Alt", true)
		# Play the sound effect
		sounds[0].play(0)
		# Reset character offsets and zoom level
		Back.Char_Offsets.x = 0
		Back.scroll.Zoom = 0.75
		return
	# Set animation for the specified character order
	Back.get_node("Characters").character_nodes[charorder].set_anim(anim, false)

# Boolean flag to control stage vanishing effect
var stage_vanish = false
