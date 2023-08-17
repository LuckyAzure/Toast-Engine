extends Sprite2D

var data = [0,0,0,0]

func _ready():
	position.y = (get_tree().get_current_scene().song_time - data[0]) * 2.4
	show()

func _process(delta):
	position.y = (get_tree().get_current_scene().song_time - data[0]) * 2.4
