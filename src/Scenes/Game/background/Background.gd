extends CanvasLayer

func _ready():
	$Characters.load_players(get_parent().characters)
