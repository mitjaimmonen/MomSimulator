extends Node2D

var intro_node
var guide_node
var game_node
var outro_node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	intro_node = get_node("Intro")
	intro_node.visible = true

	guide_node = get_node("Ohjeistus")
	guide_node.visible = false

	game_node = get_node("Peli")
	game_node.visible = false

	outro_node = get_node("Outro")
	outro_node.visible = false
	
	GameManager.scene_state = GameManager.SceneState.INTRO
	intro_node._start()

func _on_intro_finished():
	intro_node.visible = false
	guide_node.visible = true
	GameManager.scene_state = GameManager.SceneState.GUIDE
	
