extends Node

const def_animations = [
	"Left",
	"Down",
	"Up",
	"Right",
	"Left_Miss",
	"Down_Miss",
	"Up_Miss",
	"Right_Miss"
]

var char_node = preload("res://src/Scenes/Game/background/character.tscn")
var character_nodes = []

func _load(characters,stagedata):
	create_char(characters[0],Vector2(stagedata.Player.x,stagedata.Player.y))
	create_char(characters[1],Vector2(stagedata.Enemy.x,stagedata.Enemy.y))
	create_char(characters[2],Vector2(stagedata.GF.x,stagedata.GF.y))

func create_char(character,pos):
	if character != null:
		var instance = char_node.instantiate()
		add_child(instance)
		instance.charname = character
		instance.position = pos
		instance._load()
		character_nodes.append(instance)
	else:
		character_nodes.append(null)

func _set_anim(type,_order,charorder):
	if character_nodes[charorder] != null:
		character_nodes[charorder].set_anim(def_animations[type])

func _on_timeline_second_beat():
	for i in character_nodes.size():
		if character_nodes[i] != null:
			if character_nodes[i].current_animation == "Idle" and !character_nodes[i].loop:
				character_nodes[i].set_anim("Idle")
