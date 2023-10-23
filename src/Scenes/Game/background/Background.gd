extends CanvasLayer

var stagedata

func _load(data):
	$Stage._load(data.stage)
	stagedata = $Stage.stage_data.Stage
	Zoom = stagedata.Camera.zoom
	Offsets.Position = Vector2(stagedata.Camera.offsetx,stagedata.Camera.offsety)
	$Characters._load(data,stagedata)
	instant_scroll()

var Position = Vector2(640,360)
var Zoom = 0.75
var Rotation_Degrees = 0.0

var Offsets = {
	"Position": Vector2(0, 0),
	"Zoom": 0.0,
	"Rotation_Degrees": 0.0
}

var Char_Offsets = {
	"Position": Vector2(0, 0),
	"Zoom": 0.0,
	"Rotation_Degrees": 0.0
}

var bump = 0.0
var bump_speed = 5

var scroll_speed = 5
var force_camera = false

var scroll = {
	"Position": Vector2(0, 0),
	"Zoom": 0.0,
	"Rotation_Degrees": 0.0
}

func _process(delta):
	scroll.Position = lerp(scroll.Position,Position + Offsets.Position + Char_Offsets.Position, delta * scroll_speed)
	scroll.Zoom = lerp(scroll.Zoom,Zoom + Offsets.Zoom + Char_Offsets.Zoom, delta * scroll_speed)
	scroll.Rotation_Degrees = lerp(scroll.Rotation_Degrees, Rotation_Degrees + Offsets.Rotation_Degrees + Char_Offsets.Rotation_Degrees, delta * scroll_speed)
	bump = lerp(bump, 0.0, delta * bump_speed)
	
	$Camera.position = scroll.Position
	$Camera.zoom = Vector2(scroll.Zoom + bump,scroll.Zoom + bump)
	$Camera.rotation_degrees = scroll.Rotation_Degrees

func _on_timeline_section_changed(info):
	bump += 0.05
	if !force_camera:
		var pos = $Characters.character_nodes[int(!info.mustHitSection)].position
		var campos = $Characters.character_nodes[int(!info.mustHitSection)].chardata.cameraoffset
		Char_Offsets.Position = pos + Vector2(campos.x,campos.y)

#------------------------------------------------------------
#Functions

func instant_scroll():
	scroll.Position = Position
	scroll.Zoom = Zoom
	scroll.Rotation_Degrees = Rotation_Degrees

func set_camera_pos(pos = null, zoom = null, rotate = null, instant = false):
	if pos != null:
		Position = pos
		if instant:
			scroll.Position = pos
	
	if zoom != null:
		Zoom = zoom
		if instant:
			scroll.Zoom = zoom
	
	if rotate != null:
		Rotation_Degrees = rotate
		if instant:
			scroll.Rotation_Degrees = rotate
