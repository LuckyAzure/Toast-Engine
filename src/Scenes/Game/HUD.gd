extends CanvasLayer

var Position = Vector2(640,360)
var Zoom = 1
var Rotation_Degrees = 0

const scroll_speed = 7.5

func _process(delta):
	offset = offset.lerp(Position, delta * scroll_speed)
	scale = scale.lerp(Vector2(Zoom,Zoom), delta * scroll_speed)

func _on_timeline_section_changed(info):
	scale += Vector2(0.025,0.025)
