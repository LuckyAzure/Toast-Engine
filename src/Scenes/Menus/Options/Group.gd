extends Label

@onready var main = get_parent()

var data = {
	"text": "",
	"offset": 0,
	"order": 0
}

func _process(delta):
	text = data.text
	position = Vector2(
		main.group_offset + data.offset + 38,
		24
	)
	
	modulate.a = sin(position.x / 320)
