extends Node

# Event data with timestamps and corresponding actions
var events = [
	[138600, ["phase_2"]],
	[224000, ["black", "hide_notes"]],
	[229000, ["play_video"]],
	[250000, ["show_notes"]],
	[272000, ["show"]],
]

# Reference to the "Background" node
var Back = get_parent().get_node("Background")
var Timeline = get_parent().get_node("HUD/Chart/Timeline")

# Array to store audio streams
var sounds = [null]

# Boolean flag to control camera direction
var dir_cam = true

# Path to the .ogv file (make sure it's correctly placed in the Godot project directory)
var video_path = "res://mods/Stinkicidal Fungality/songs/well-done/cutscene.ogv"
var video_player

# Function called when the node is ready
func _ready():
	get_tree().get_current_scene().get_node("HUD/Chart/Notes").sections[0].position.x = 0
	get_tree().get_current_scene().get_node("HUD/Chart/Notes").sections[1].hide()
	print("hey")
	
	# Set the default clear color for rendering (black background)
	RenderingServer.set_default_clear_color(Color(0, 0, 0))

	# Create a VideoPlayer node
	video_player = VideoStreamPlayer.new()
	
	# Load the video stream
	var video_stream = load(video_path)
	
	# Check if the video loaded successfully
	if video_stream:
		video_player.stream = video_stream
	else:
		print("Failed to load video:", video_path)
		return
	video_player.volume = 0
	video_player.z_index = -1
	
	# Add VideoPlayer as a child to the current node
	get_tree().get_current_scene().get_node("HUD").add_child(video_player)
	
	# Set VideoPlayer properties if necessary
	video_player.scale = Vector2(3,3)
	video_player.set_position(Vector2(-480, -360))    # Adjust position if needed

# Function called every frame
func _process(delta):
	if video_player.is_playing():
		video_player.show()
	else:
		video_player.hide()

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
		"phase_2":
			Back.get_node("Characters").character_nodes[1]._preload(Back.get_node("Characters").preload_characters[0])
			Back.get_node("Characters").character_nodes[1].position = Vector2(-800, 400)
			Back.get_node("Stage/Sprites/phase1").hide()
			Back.get_node("Stage/Sprites/phase1_fog").hide()
			Back.get_node("Stage/Sprites/phase1_sator").hide()
			Back.Zoom = 0.75
		"play_video":
			video_player.play()
		"hide_notes":
			get_tree().get_current_scene().get_node("HUD/Chart/Notes").hide()
		"show_notes":
			get_tree().get_current_scene().get_node("HUD/Chart/Notes").show()
		"zoom_in":
			# Handle zoom in event
			Back.scroll_speed = 0.2
			Back.Offsets.Zoom = 100.0
			Back.force_camera = true
			stage_vanish = true
			dir_cam = false
		"black":
			Back.get_node("Characters").hide()
			Back.get_node("Stage").hide()
		"show":
			Back.get_node("Characters").show()
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
	var distance = 10.0
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

# Function to handle custom animations
func custom_anim(data, charorder, type):
	var anim = def_animations[int(data[1]) % 4]
	# Set animation for the specified character order
	Back.get_node("Characters").character_nodes[charorder].set_anim(anim, false)

# Boolean flag to control stage vanishing effect
var stage_vanish = false
