extends CanvasLayer

# ------------------------------------------------------------------------

func _ready():
	$Flash.modulate.a = 0

# ------------------------------------------------------------------------

var state = ""

func _process(delta):
	if !$Music.playing and state == "Menu":
		Check_Music()
	
	# Important Functions
	_Fullscreen()
	_Debug_Tick()
	_Fade_Tick(delta)
	_Scene_Tick()
	
# ------------------------------------------------------------------------

func _Fullscreen():
	# Toggles Fullscreen
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
# ------------------------------------------------------------------------

var Stats = {
	"FPS": {"boolean" : true, "value" : 0},
	"Memory": {"boolean" : false, "value" : 0},
	"Memory_Peak": {"boolean" : false, "value" : 0}
}

func _Debug_Tick():
	# Changes the "Stats" variables 
	Stats.FPS.value = Engine.get_frames_per_second()
	Stats.Memory.value = stepify(Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0,0.01)
	Stats.Memory_Peak.value = stepify(Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 1048576.0,0.01)
	
	$Debug.text = "" # Clears text
	
	if Stats.FPS.boolean:
		$Debug.text += "FPS: " + str(Stats.FPS.value) # Frames per Second
	if Stats.Memory.boolean:
		$Debug.text += "\nMemory: " + str(Stats.Memory.value) + " MB" # Memory Usage
	if Stats.Memory_Peak.boolean:
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

func _Scene_Tick():
	if scenechange.boolean and $Fade.modulate.a == 1:
		scenechange.boolean = false
		reversefade = false
		scene = get_tree().change_scene(scene)
		Check_Music()
		resetfade()

func change_scene(next_scene,instant,type):
	if instant: # Instantly goes to the next scene
		scene = get_tree().change_scene(next_scene)
		Check_Music()
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

func Check_Music():
	if !$Music.playing:
		var path
		match state:
			"Menu":
				path = "res://assets/musics/sereneLoop.ogg"
		if state == "":
			pass
		else:
			var audio_loader = AudioLoader.new()
			$Music.set_stream(audio_loader.loadfile(path))
			$Music.volume_db = 1
			$Music.pitch_scale = 1
			$Music.play()
