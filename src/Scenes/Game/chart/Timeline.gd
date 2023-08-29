extends Node

signal section_changed

# Properties
var bpm : float = 120
var sections : Array = []
var current_section = -1

func initialize():
	current_section = -1
	bpm = get_parent().chart.info.bpm

func _process(delta):
	var chart = get_parent().chart
	var audio_player = get_parent().get_node_or_null("Instrumental")
	
	if audio_player.playing:
		var section_per_milisecond = 2400 / (bpm * 0.01)
		var audio_position = get_tree().get_current_scene().song_time
		
		if current_section == -1:
			sections.append(section_per_milisecond)
			current_section += 1
		
		if audio_position > sections[current_section]:
			sections.append(sections[current_section] + section_per_milisecond)
			current_section += 1
			emit_signal("section_changed")
			
			var section_info = chart.sections[current_section]
			process_section(section_info)

func process_section(section_info):
	var changeBPM = section_info.has("changeBPM") and section_info["changeBPM"]
	
	# Example: Change BPM if required
	if changeBPM:
		bpm = section_info["bpm"]
	
