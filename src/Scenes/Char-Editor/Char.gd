extends Marker2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = 100.0
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 200.0
	if Input.is_key_pressed(KEY_W):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		position.y += speed * delta
	if Input.is_key_pressed(KEY_A):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_D):
		position.x += speed * delta
