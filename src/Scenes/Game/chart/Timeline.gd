extends Node

signal section_changed

signal second_beat
signal first_beat

# Properties
var bpm = 120
var sections : Array = []
var current_section = 0
var beat_count = 0
var section = {}

func initialize():
	current_section = 0
	
	#get informations
	var chart = get_parent().chart
	bpm = chart.info.bpm
	sections = chart.sections
	emit_signal("section_changed",sections[current_section][1])

func _process(_delta):
	var chart = get_parent().chart
	var audio_player = get_parent().get_node_or_null("Instrumental")

	if audio_player.playing:
		var audio_position = get_parent().song_time
		
		#calculate section length
		var section_length = sections[current_section][0] - sections[current_section - 1][0]
		print(section_length)

		while audio_position > sections[current_section][0]:
			current_section += 1
			if current_section < sections.size():
				emit_signal("beat",4)
				emit_signal("section_changed",sections[current_section][1]) 
				section = chart.sections[current_section]
