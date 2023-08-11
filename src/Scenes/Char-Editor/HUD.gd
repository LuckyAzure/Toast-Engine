extends CanvasLayer

func _on_save_pressed():
	get_tree().get_current_scene().save_char()

func _on_Load_pressed():
	get_tree().get_current_scene().charname = $CharName.text
	get_tree().get_current_scene().load_char()

func _on_animations_item_selected(index):
	get_tree().get_current_scene().save_animation(get_tree().get_current_scene().current_animation)
	get_tree().get_current_scene().load_animation($Animations.get_item_text(index))
