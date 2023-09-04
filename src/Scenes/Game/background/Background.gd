extends CanvasLayer

var stagedata

func _ready():
	$Stage._load(get_parent().stage)
	stagedata = $Stage.stage_data.Stage
	Zoom = stagedata.Camera.zoom
	Offsets.Position = Vector2(stagedata.Camera.offsetx,stagedata.Camera.offsety)
	$Characters._load(get_parent().characters,stagedata)

var Position = Vector2(640,360)
var Zoom = 0.75
var Rotation_Degrees = 0

var Offsets = {
	"Position": Vector2(0, 0),
	"Zoom": 0,
	"Rotation_Degrees": 0
}

var Char_Offsets = {
	"Position": Vector2(0, 0),
	"Zoom": 0,
	"Rotation_Degrees": 0
}

const scroll_speed = 5

func _process(delta):
	timer2 += delta * 5
	timer += delta * 10 * abs(sin(timer2) )
	var camerathingy = Vector2(sin(timer) * 50,cos(timer) * 50)
	
	$Camera.position = $Camera.position.lerp(Position + Offsets.Position + Char_Offsets.Position + camerathingy, delta * scroll_speed)
	$Camera.zoom = $Camera.zoom.lerp(Vector2(Zoom,Zoom), delta * scroll_speed)

func _on_timeline_section_changed(info):
	$Camera.zoom += Vector2(0.05,0.05)
	var pos = $Characters.character_nodes[int(!info.mustHitSection)].position
	var campos = $Characters.character_nodes[int(!info.mustHitSection)].chardata.cameraoffset
	Char_Offsets.Position = pos + Vector2(campos.x,campos.y)

var timer = 0
var timer2 = 0