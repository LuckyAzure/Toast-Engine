extends Node2D

var misses = 0
var score = 0
var maxscore = 0
var time_node = null

func _load():
	if !Save.data.options.visuals.timer_bar:
		$Time.hide()
	if Save.data.options.visuals.hide_hud:
		$HUDText.hide()
	time_node = get_parent().get_node("Chart/Instrumental")
	$Time.max_value = time_node.stream.get_length()
	reload_icons()

func _process(delta):
	update_timer()
	update_status()
	health_bar(delta)

func update_timer():
	if time_node.playing:
		$Time.value = time_node.get_playback_position()

func update_status():
	var sections = Global.get_node_scene("HUD/Chart/Notes").sections
	var status = sections[0].status
	
	if status.accuracy != 0 or status.score != 0:
		$HUDText/Score.text = "Score: " + str(status.score) + " | Misses: " + str(status.misses) + " | Accuracy: " + str(snapped(status.accuracy * 100.0, 0.01)) + "%"
	#discord_sdk.state = $HUDText/Score.text
	#discord_sdk.refresh()

func reload_icons():
	var chars = Global.get_node_scene("Background/Characters").character_nodes
	$"HUDText/Icons/Left".texture = chars[1].icon_texture
	$"HUDText/Icons/Right".texture = chars[0].icon_texture
	has_winning_icons = [
		chars[1].chardata.has_winning_icon,
		chars[0].chardata.has_winning_icon
	]
	$"HUDText/Front".get_theme_stylebox("background").bg_color = Color.html(chars[1].chardata.hp_color)
	$"HUDText/Front".get_theme_stylebox("fill").bg_color = Color.html(chars[0].chardata.hp_color)

var hp = 10000.0
@onready var Icons = [
	get_node("HUDText/Icons/Left"),
	get_node("HUDText/Icons/Right")
]
var has_winning_icons = [false,false]

func health_bar(delta):
	hp = clamp(hp,0.0,20000.0)
	
	$HUDText/Front.value = lerp($HUDText/Front.value,hp,5.0 * delta)
	$HUDText/Icons.position.x = 296 - (592 * ($HUDText/Front.value / 20000.0))
	$"HUDText/Icons".scale = $"HUDText/Icons".scale.lerp(Vector2(0.9,0.9),10 * delta)
	
	for Icon_item in Icons.size():
		var Icon = Icons[Icon_item]
		var offset = 3 if has_winning_icons[Icon_item] else 2
		var offset2 = 150 if has_winning_icons[Icon_item] else 0
		Icon.region_rect = Rect2(offset2,0,Icon.texture.get_width() / offset,Icon.texture.get_height())
		Icon.position.x = lerp(Icon.position.x,0.0,10 * delta)
	
	if hp < 2000:
		Icons[1].region_rect.position.x += Icons[1].region_rect.size.x
		if has_winning_icons[0]:
			Icons[0].region_rect.position.x -= Icons[0].region_rect.size.x
	elif hp > 18000:
		Icons[0].region_rect.position.x += Icons[0].region_rect.size.x
		if has_winning_icons[1]:
			Icons[1].region_rect.position.x -= Icons[1].region_rect.size.x

func _on_timeline_beat_changed(_beat):
	$"HUDText/Icons".scale = Vector2(1.1,1.1)
	Icons[0].position.x = -5
	Icons[1].position.x = 5
