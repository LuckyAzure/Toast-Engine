extends CanvasLayer

func _ready():
	$Flash.modulate.a = 0

func _process(delta):
	if $Fade.modulate.a > 0:
		$Fade.modulate.a -= 2 * delta
	if $Flash.modulate.a > 0:
		$Flash.modulate.a -= 2 * delta

func _resetfade():
	$Fade.modulate.a = 1

func _flash():
	$Flash.modulate.a = 1
