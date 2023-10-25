class_name SaveData 

var options = {
	"gameplay": {
		"downscroll": false,
		"middlescroll": false,
		"opponent_notes": true,
		"ghost_tapping": true,
		"disable_reset": false
	},
	"audio": {
		"offset": 0.0,
		"music": 1.0,
		"sound": 1.0
	},
	"controls": {
		"left": KEY_A,
		"down": KEY_S,
		"up": KEY_K,
		"right": KEY_L
	},
	"graphics": {
		"low_quality": false,
		"shaders": true,
		"fps": 240
	},
	"visuals_and_ui": {
		"note_splashes": true,
		"hide_hud": false,
		"timer_bar": true,
		"flashing_lights": false,
		"camera_zooms": true,
		"score_text_zoom_on_hit": false,
		"show_fps": false,
		"show_vram": false,
		"hide_combo": false,
		"combo_stack": true,
		"adjust_combo": {
			"x": 0,
			"y": 0
		}
	}
}

func _ready():
	print("anyád")
