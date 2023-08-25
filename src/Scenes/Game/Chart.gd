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
		var max_adjustment = delta * 1000.0 * $Instrumental.pitch_scale
		var adjustment = clamp(time_difference, -max_adjustment, max_adjustment)
		
		current_scene.song_time += adjustment
		process_notes()
		
		var delay = int(playback_adjusted_time) - int(scene_song_time)
		if delay > 30: current_scene.song_time = playback_adjusted_time
		$Label.text = "delay: " + str(delay)

var count = 0
var note = preload("res://src/Scenes/Game/chart/note.tscn")

var NoteOrder = [[],[],[],[],[],[],[],[]]

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
	var inputs = get_tree().get_current_scene().input
	if chart.notes.size() > count:
		if chart.notes[count][0] < song_time + 2000:
			var instance = note.instantiate()
			get_node(def_note_nodes[chart.notes[count][1]]).add_child(instance)
			instance.data = chart.notes[count]
			instance.note_position = chart.notes[count][0]
			if chart.notes[count][1] > 3:
				instance.note_data.bot = true
			else:
				NoteOrder[chart.notes[count][1]].append(chart.notes[count][0])
				instance.note_data.bot = false
				instance.note_data.input = inputs[chart.notes[count][1]]
			instance.texture = $Notes.data[def_notes[int(chart.notes[count][1]) % 4]]["Note"]["texture"][0]
			instance.get_node("Sustain").texture = $Notes.data[def_notes[int(chart.notes[count][1]) % 4]]["Note_Long"]["texture"][0]
			instance.get_node("Sustain/End").texture = $Notes.data[def_notes[int(chart.notes[count][1]) % 4]]["Note_Long_End"]["texture"][0]
			count += 1

func load_hud_notes_texture():
	for type in def_note_nodes.size():
		get_node(def_note_nodes[type]).texture = $Notes.data[def_notes[type % 4]]["HUD_Idle"]["texture"][0]

func load_audio():
	var song_name = get_tree().get_current_scene().song_name
	var inst_path = "res://assets/songs/" + song_name + "/Inst.ogg"
	var voices_path = "res://assets/songs/" + song_name + "/Voices.ogg"
	$Instrumental.stream = AudioStreamOggVorbis.load_from_file(inst_path)
	$Voices.stream = AudioStreamOggVorbis.load_from_file(voices_path)

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
			if note_data[1] == -1 or note_data[1] > 7:
				continue
			
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
	if chart_data.has("events"):
		chart.psych_events = chart_data.events
		chart_data.erase("events")
	chart.info = chart_data
	chart.notes.sort_custom(func(a, b): return a[0] < b[0])

func notemiss(order):
	get_parent().get_node("Status").maxscore += 350
	get_parent().get_node("Status").misses += 1

func notehit(order,distance):
	get_parent().get_node("Status").maxscore += 350
	if distance < 45:
		get_parent().get_node("Status").score += 350
	elif distance < 90:
		get_parent().get_node("Status").score += 200
	elif distance < 135:
		get_parent().get_node("Status").score += 100
	else:
		get_parent().get_node("Status").score += 50
