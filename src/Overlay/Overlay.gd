extends CanvasLayer

# ------------------------------------------------------------------------

func _ready():
	$Version.text = Global.version
	$Flash.modulate.a = 0

# ------------------------------------------------------------------------

var state = ""

func _process(delta):
	
	# Important Functions
	_Fullscreen()
	_Debug_Tick()
	_Fade_Tick(delta)
	_Scene_Tick()
	
# ------------------------------------------------------------------------

func _Fullscreen():
	# Toggles Fullscreen
	if Input.is_action_just_pressed("ui_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	
# ------------------------------------------------------------------------

var Stats = {
	"FPS": {"boolean" : true, "value" : 0},
	"Memory": {"boolean" : true, "value" : 0},
	"Memory_Peak": {"boolean" : true, "value" : 0},
	"Video": {"boolean" : true, "value" : 0}
}

func _Debug_Tick():
	# Changes the "Stats" variables 
	Stats.FPS.value = Engine.get_frames_per_second()
	Stats.Memory.value = snapped(Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0,0.01)
	Stats.Memory_Peak.value = snapped(Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 1048576.0,0.01)
	Stats.Video.value = snapped(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0,0.01)
	
	$Debug.text = "" # Clears text
	
	if Save.data.options.graphics.show_fps:
		$Debug.text += "FPS: " + str(Stats.FPS.value) # Frames per Second
	if Save.data.options.graphics.show_vram:
		$Debug.text += "\nVRAM: " + str(Stats.Video.value) + " MB" # Memory Usage
	if Save.data.options.graphics.show_memory:
		$Debug.text += "\nMemory: " + str(Stats.Memory.value) + " MB" # Memory Usage
	if Save.data.options.graphics.show_memory_leak:
		$Debug.text += "\nMemory Peak: " + str(Stats.Memory_Peak.value) + " MB" # Max Memory Used
	
	
# ------------------------------------------------------------------------

var reversefade = false

func _Fade_Tick(delta):
	# Black Fade Transaction
	if reversefade:
		if $Fade.modulate.a < 1:
			$Fade.modulate.a += 2 * delta
		else:
			$Fade.modulate.a = 1
	else:
		if $Fade.modulate.a > 0:
			$Fade.modulate.a -= 2 * delta
		else:
			$Fade.modulate.a = 0
	
	# Flash
	if $Flash.modulate.a > 0:
		$Flash.modulate.a -= 2 * delta

func resetfade():
	$Fade.modulate.a = 1

func flash():
	$Flash.modulate.a = 1

# ------------------------------------------------------------------------

var scene
var scenechange = {"boolean" : false, "type" : "Fade"}
var prev_scene = null

func _Scene_Tick():
	if scenechange.boolean and $Fade.modulate.a == 1:
		scenechange.boolean = false
		reversefade = false
		get_tree().paused = false
		scene = get_tree().change_scene_to_file(scene)
		resetfade()

func change_scene_to_file(next_scene, type = "Fade", instant = false):
	prev_scene = scene
	if instant: # Instantly goes to the next scene
		get_tree().paused = false
		scene = get_tree().change_scene_to_file(next_scene)
	else: # Goes to the next scene with effect
		scenechange.type = type
		match type:
			"Fade":
				scenechange.boolean = true
				scene = next_scene
				reversefade = true
			"Scroll":
				scenechange.boolean = true
				scene = next_scene
				reversefade = true

# ------------------------------------------------------------------------
