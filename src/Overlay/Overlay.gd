extends CanvasLayer

var Stats = {"FPS":0,"Memory":0,"Memory_Peak":0}

func _process(_delta):
	# Changes the "Stats" variables 
	Stats.FPS = Engine.get_frames_per_second()
	Stats.Memory = stepify(OS.get_static_memory_usage() / 1048576.0,0.01)
	Stats.Memory_Peak = stepify(OS.get_static_memory_peak_usage() / 1048576.0,0.01)
	
	# Important Functions
	_Fullscreen()
	_DebugStatus()

# ------------------------------------------------------------------------

func _Fullscreen():
	# Toggles Fullscreen
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

# ------------------------------------------------------------------------

func _DebugStatus():
	$Debug.text = "" # Clears text
	$Debug.text += "FPS: " + str(Stats.FPS) # Frames per Second
	$Debug.text += "\nMemory: " + str(Stats.Memory) + " MB" # Memory Usage
	$Debug.text += "\nMemory Peak: " + str(Stats.Memory_Peak) + " MB" # Max Memory Used

# ------------------------------------------------------------------------
