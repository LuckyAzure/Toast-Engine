extends Node

var misses = 0
var score = 0

func _ready():
	$Time.max_value = get_parent().get_node("Chart/Instrumental").stream.get_length()

func _process(delta):
	timer()
	status()

func timer():
	if get_parent().get_node("Chart/Instrumental").playing:
		$Time.value = get_parent().get_node("Chart/Instrumental").get_playback_position()

func status():
	$Score.text = "Score: " + str(score) + " | Misses: " + str(misses) + " | Accuracy: N/A"
