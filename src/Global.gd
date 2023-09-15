extends Node

func scene():
	return get_tree().get_current_scene()

func get_node_scene(node_path):
	return get_tree().get_current_scene().get_node(node_path)
