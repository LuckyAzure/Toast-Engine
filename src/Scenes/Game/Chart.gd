extends Node

func _ready():
	var song_name = get_tree().get_current_scene().song_name
	var inst_path = "res://assets/songs/" + song_name + "/inst.wav"
	var voices_path = "res://assets/songs/" + song_name + "/voices.wav"
	$Instrumental.stream = load_audio(inst_path)
	$Voices.stream = load_audio(voices_path)
	$Instrumental.play()
	$Voices.play()

func load_audio(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamWAV.new()
	var bytes = file.get_buffer(file.get_length())
	sound.data = bytes
	sound.format = 1
	sound.mix_rate = 44100 * 2
	return sound
