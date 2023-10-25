extends Node

var defaultSounds = [
	["cancel", "cancelMenu.ogg"],
	["confirm", "confirmMenu.ogg"],
	["scroll", "scrollMenu.ogg"]
]

var mainSounds = {}
var Sounds = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_sounds(defaultSounds, true)

func load_sounds(datas, isMain = false):
	for i in datas:
		var sound = AudioStreamOggVorbis.load_from_file("res://assets/sounds/" + i[1])
		var audioStreamPlayer = AudioStreamPlayer.new()

		# Set the loaded sound as the stream for the AudioStreamPlayer
		audioStreamPlayer.stream = sound

		# Add the sound node to the appropriate dictionary
		if isMain:
			mainSounds.merge({i[0]: audioStreamPlayer})
		else:
			Sounds.merge({i[0]: audioStreamPlayer})

		# Add the sound node to the scene tree
		add_child(audioStreamPlayer)

func clear_sounds():
	Sounds = {}

func play(sound):
	if Sounds.has(sound):
		Sounds[sound].play()
	else:
		mainSounds[sound].play()
