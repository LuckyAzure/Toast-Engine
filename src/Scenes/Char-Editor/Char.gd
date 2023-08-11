extends Marker2D

var is_dragging = false
var offset = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = 100.0
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 200.0
	
	if is_dragging:
		position = get_global_mouse_position() / 2.5 - offset
	
	if Input.is_key_pressed(KEY_W):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		position.y += speed * delta
	if Input.is_key_pressed(KEY_A):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_D):
		position.x += speed * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var mouse_pos = get_global_mouse_position() / 2.5
				if is_mouse_in_middle():
					is_dragging = true
					offset = mouse_pos - position
			else:
				is_dragging = false

func is_mouse_in_middle() -> bool:
	var viewport_rect = get_viewport_rect()
	var viewport_center = viewport_rect.size / 2
	var mouse_pos = get_global_mouse_position()
	return viewport_rect.has_point(mouse_pos) && mouse_pos.distance_to(viewport_center) < 500.0
