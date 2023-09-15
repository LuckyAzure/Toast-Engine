extends Node

var misses = 0
var score = 0
var maxscore = 0
var time_node = null

func _load():
	time_node = get_parent().get_node("Chart/Instrumental")
	$Time.max_value = time_node.stream.get_length()

func _process(_delta):
	update_timer()
	update_status()

func update_timer():
	if time_node.playing:
		$Time.value = time_node.get_playback_position()

func update_status():
	if maxscore != 0 or score != 0:
		var accuracy = (float(score) / float(maxscore)) * 100.0
		$Score.text = "Score: " + str(score) + " | Misses: " + str(misses) + " | Accuracy: " + str(snapped(accuracy, 0.01)) + "%"
	discord_sdk.state = $Score.text
	discord_sdk.refresh()
