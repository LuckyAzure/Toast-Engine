extends Node

signal section_changed
signal beat_changed

# Properties
var bpm = 120
var sections : Array = []
var current_section = 0
var section = {}

func initialize():
	current_section = 0
	
	#get informations
	var chart = get_parent().chart
	bpm = chart.info.bpm
	sections = chart.sections
	emit_signal("section_changed",sections[current_section][1])

var beat = 0

func _process(_delta):
	var chart = get_parent().chart
	var audio_player = get_parent().get_node_or_null("Instrumental")

	if audio_player.playing:
		var audio_position = get_parent().song_time
		
		var beat_length = (sections[current_section][0] - ((sections[current_section][2] / 4.0) * (3 - beat + 1)))
		
		if audio_position > beat_length:
			emit_signal("beat_changed",beat)
			beat += 1

		while audio_position > sections[current_section][0]:
			beat = 0
			current_section += 1
			if current_section < sections.size():
				emit_signal("section_changed",sections[current_section][1]) 
				section = chart.sections[current_section]
