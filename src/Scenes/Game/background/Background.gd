extends CanvasLayer

func _ready():
	$Characters.load_players(get_parent().characters)

var Position = Vector2(640,360)
var Zoom = 0.75
var Rotation_Degrees = 0

const scroll_speed = 5

func _process(delta):
	offset = offset.lerp(Position, delta * scroll_speed)
	scale = scale.lerp(Vector2(Zoom,Zoom), delta * scroll_speed)

func _on_timeline_section_changed():
	scale += Vector2(0.05,0.05)
