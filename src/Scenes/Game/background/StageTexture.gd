extends Sprite2D

var texture_data = null
var Anim = 0
var x = 0
var y = 0
var sx = 0
var sy = 0

const ANIMATION_SPEED = 10

@onready var camera = get_parent().get_parent().get_node("Camera")

func _ready():
	get_tree().get_current_scene().get_node("HUD/Chart/Timeline").second_beat.connect(section_changed)

func _process(delta):
	if texture_data.has("animations"):
		_Animation(delta)
	else:
		UpdatePosition()

func UpdatePosition():
	var camerapos = camera.position
	position = Vector2(x + camerapos.x * texture_data.sensitivity.x, y + camerapos.y * texture_data.sensitivity.y)
	scale = Vector2(sx, sy)

func _Animation(delta):
	var target = texture_data.animations[Anim]
	var lerp_speed = ANIMATION_SPEED * delta
	
	x = lerp(x, target.x, lerp_speed)
	y = lerp(y, target.y, lerp_speed)
	sx = lerp(sx, target.width, lerp_speed)
	sy = lerp(sy, target.height, lerp_speed)
	
	UpdatePosition()

func section_changed():
	if texture_data.has("animations") and (texture_data.animations.size() - 1) > Anim:
		Anim += 1
	else:
		Anim = 0
