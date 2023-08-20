extends Sprite2D

var data = [0,0,0,0]

func _ready():
	position.y = (get_tree().get_current_scene().song_time - data[0]) * 2.4
	show()

func _process(delta):
	if (get_tree().get_current_scene().song_time - (data[0] + data[2])) > 0:
		queue_free()
	if (get_tree().get_current_scene().song_time - data[0]) <= 0:
		position.y = (get_tree().get_current_scene().song_time - data[0]) * 2.4
	else:
		position.y = 0
