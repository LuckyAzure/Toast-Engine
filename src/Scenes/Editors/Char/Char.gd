extends Marker2D

var offset = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = 100.0
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 200.0
	
	if Input.is_key_pressed(KEY_W):
		$Image.position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		$Image.position.y += speed * delta
	if Input.is_key_pressed(KEY_A):
		$Image.position.x -= speed * delta
	if Input.is_key_pressed(KEY_D):
		$Image.position.x += speed * delta
