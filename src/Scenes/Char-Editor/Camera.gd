extends Camera2D

var speed = 500.0
var zoom_speed = 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 1000.0
	else:
		speed = 500.0
	
	move_camera(delta)
	zoom_camera(delta)

func move_camera(delta):
	var movement = Vector2.ZERO
	if Input.is_key_pressed(KEY_UP):
		movement.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		movement.y += 1
	if Input.is_key_pressed(KEY_LEFT):
		movement.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		movement.x += 1
	
	position += movement.normalized() * speed * delta

func zoom_camera(delta):
	var zoom_change = Vector2.ZERO
	if Input.is_key_pressed(KEY_PAGEUP):
		zoom_change += Vector2.ONE * (speed * zoom_speed * delta)
	if Input.is_key_pressed(KEY_PAGEDOWN):
		zoom_change -= Vector2.ONE * (speed * zoom_speed * delta)

	zoom += zoom_change
	zoom = clamp(zoom, Vector2(0.1, 0.1), Vector2(10.0, 10.0))
