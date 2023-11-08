extends Node

var data
var default = {
	"options": {
		"gameplay": {
			"ghost": true,
			"scroll": 0,
			"opponent_notes": true,
			"disable_reset": false
		},
		"audio": {
			"offset": 0.0
		},
		"controls": {
			"left": KEY_A,
			"down": KEY_S,
			"up": KEY_K,
			"right": KEY_L
		},
		"graphics": {
			"fps": 60,
			"show_fps": true,
			"show_memory": true,
			"show_memory_leak": true,
			"show_vram": true
		},
		"visuals": {
			"hide_hud": false,
			"timer_bar": true
		}
	}
}

var json_path = "user://save.json"

func save_data():
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_data():
	if not FileAccess.file_exists(json_path):
		data = default
		save_data()
	else:
		var file = FileAccess.open(json_path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()
