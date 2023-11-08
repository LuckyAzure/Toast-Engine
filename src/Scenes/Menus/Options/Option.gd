extends Label

@onready var main = get_parent()

var data = {
	"text": "",
	"offset": 0,
	"order": 0,
	"group": null,
	"variable": null
}

func _process(delta):
	hold_cooldown -= 1 * delta
	movement(delta)
	read_data()

func read_data():
	var value = Save.data.options[data.group[1]][data.variable[0]]
	var type = data.variable[1]
	
	match type:
		BOOLEAN:
			$Text.text = "On" if value else "Off"
		PERCENTAGE:
			$Text.text = str(value * 100) + "%"
		RANGE:
			$Text.text = data.variable[2][value]
		VALUE:
			$Text.text = str(value)
		BIND:
			$Text.text = char(int(value))

func data_changed(dir = 1):
	var new_value
	var value = Save.data.options[data.group[1]][data.variable[0]]
	var type = data.variable[1]
	
	if type == BOOLEAN:
		new_value = !value
		Save.data.options[data.group[1]][data.variable[0]] = new_value
	elif type == RANGE:
		new_value = abs(int(value) + (1 * dir)) % data.variable[2].size()
		Save.data.options[data.group[1]][data.variable[0]] = new_value
	elif type == BIND:
		$Text.text = char(value)
		Save.data.options[data.group[1]][data.variable[0]] = new_value

var hold_cooldown = 0

func hold(dir = 1):
	if hold_cooldown > 0:
		return
	hold_cooldown = 0.04
	
	var new_value
	var value = Save.data.options[data.group[1]][data.variable[0]]
	var type = data.variable[1]
	
	if type == PERCENTAGE:
		new_value = clamp(value + (0.05 * dir),0.0, 1.0)
		Save.data.options[data.group[1]][data.variable[0]] = new_value
	elif type == VALUE:
		var limits = data.variable[2]
		new_value = clamp(value + (limits[0] * dir), limits[1][0], limits[1][1])
		Save.data.options[data.group[1]][data.variable[0]] = new_value

func movement(delta):
	text = data.text
	position = Vector2(
		128,
		data.offset + 92
	)
	
	var brightness = 0.5
	
	if data.order == main.select and main.in_group:
		brightness = 1.0
	
	modulate.v = lerp(modulate.v,brightness,10.0 * delta)

enum {
	BOOLEAN,
	PERCENTAGE,
	RANGE,
	VALUE,
	BIND
}
