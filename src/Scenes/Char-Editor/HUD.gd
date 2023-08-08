extends CanvasLayer



func _on_apply_pressed():
	get_tree().get_current_scene().save_animation()


func _on_save_pressed():
	get_tree().get_current_scene().save_char()


func _on_animations_item_selected(index):
	get_tree().get_current_scene().load_animation($Animations.get_item_text(index))
