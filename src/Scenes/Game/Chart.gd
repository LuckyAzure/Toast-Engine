extends Node

var chart = {
	"notes": [],
	"sections": [],
	"info": {},
	"psych_events": []
}

func _ready():
	load_audio()
	load_chart()
	$Instrumental.play(0)
	$Voices.play(0)

func _process(delta):
	$Label.text = str($Instrumental.get_playback_position() * 1000.0)

func load_audio():
	var song_name = get_tree().get_current_scene().song_name
	var inst_path = "res://assets/songs/" + song_name + "/inst.ogg"
	var voices_path = "res://assets/songs/" + song_name + "/voices.ogg"
	$Instrumental.stream = ResourceImporterOggVorbis.load_from_file(inst_path)
	$Voices.stream = ResourceImporterOggVorbis.load_from_file(voices_path)

func load_chart():
	var song_name = get_tree().get_current_scene().song_name
	var song_path = "res://assets/songs/" + song_name + "/" + song_name + ".json"
	
	#Load the JSON data
	var file = FileAccess.open(song_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	var chart_data = JSON.parse_string(json_text).song
	
	#Process and organize notes
	for note in chart_data.notes:
		var section_notes = note.sectionNotes
		chart.sections.append(note.duplicate().erase("sectionNotes"))
		
		var must_hit_section = note.mustHitSection
		for note_data in section_notes:
			var time = note_data[0]
			var note_type = note_data[1]
			var sustain = note_data[2]
			var misc = 0
			if note_data.size() > 3:
				misc = note_data[3]
			
			if must_hit_section:
				note_type = int(note_type + 4) % 8
			chart.notes.append([time, note_type, sustain, misc])
	
	chart_data.erase("notes")
	chart.psych_events = chart_data.events
	chart_data.erase("events")
	chart.info = chart_data
	chart.notes.sort()
	print(chart.info)
