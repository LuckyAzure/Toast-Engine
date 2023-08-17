extends Node

var chart = {
	"notes": [],
	"sections": [],
	"info": {},
	"psych_events": []
}

func _ready():
	$Notes.load_notes_texture()
	load_hud_notes_texture()
	load_audio()
	load_chart()
	$Instrumental.play(0)
	$Voices.play(0)

func _process(delta):
	var current_scene = get_tree().get_current_scene()

	var song_time = $Instrumental.get_playback_position()
	var scene_song_time = current_scene.song_time

	if $Instrumental.playing:
		var output_latency = AudioServer.get_output_latency()
		var time_since_last_mix = AudioServer.get_time_since_last_mix()
		var playback_adjusted_time = (song_time + time_since_last_mix - output_latency) * 1000.0

		var time_difference = playback_adjusted_time - scene_song_time
		var max_adjustment = delta * 1000.0  #Adjust this factor for smoother interpolation
		var adjustment = clamp(time_difference, -max_adjustment, max_adjustment)

		current_scene.song_time += adjustment

		process_notes()

		var delay = int(playback_adjusted_time) - int(scene_song_time)
		$Label.text = "delay: " + str(delay)



var count = 0
var note = preload("res://src/Scenes/Game/chart/note.tscn")

var def_note_nodes = [
	"Notes/P1/Left",
	"Notes/P1/Down",
	"Notes/P1/Up",
	"Notes/P1/Right",
	
	"Notes/P2/Left",
	"Notes/P2/Down",
	"Notes/P2/Up",
	"Notes/P2/Right"
]

var def_notes = [
	"Left",
	"Down",
	"Up",
	"Right",
]

func process_notes():
	var song_time = get_tree().get_current_scene().song_time
	if chart.notes.size() > count:
		if chart.notes[count][0] > song_time - 5000:
			var instance = note.instantiate()
			get_node(def_note_nodes[chart.notes[count][1]]).add_child(instance)
			instance.data = chart.notes[count]
			instance.texture = $Notes.data[def_notes[int(chart.notes[count][1]) % 4]]["Note"]["texture"][0]
			count += 1

func load_hud_notes_texture():
	for type in def_note_nodes.size():
		get_node(def_note_nodes[type]).texture = $Notes.data[def_notes[type % 4]]["HUD_Idle"]["texture"][0]

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
			
			if !must_hit_section:
				note_type = int(note_type + 4) % 8
			chart.notes.append([time, note_type, sustain, misc])
	
	chart_data.erase("notes")
	chart.psych_events = chart_data.events
	chart_data.erase("events")
	chart.info = chart_data
	chart.notes.sort()
