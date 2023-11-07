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
		128,
		data.offset + 92
	)
	
	var brightness = 0.5
	
	if data.order == main.select and main.in_group:
		brightness = 1.0
	
	modulate.v = lerp(modulate.v,brightness,10.0 * delta)
