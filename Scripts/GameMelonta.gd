extends Node2D

var intro_node
var guide_node
var game_node
var outro_node


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting game scene")
	intro_node = get_node("Intro")
	intro_node.visible = true

	guide_node = get_node("Ohjeistus")
	guide_node.visible = false

	game_node = get_node("Peli")
	game_node.visible = false

	outro_node = get_node("Outro")
	outro_node.visible = false
	
	# GameManager.game_state = GameManager.GameState.INTRO
	print("Starting game scene intro node")
	intro_node._start()

func _on_intro_finished():
	print("Scene intro finished")
	intro_node.visible = false
	guide_node.visible = true
	# GameManager.game_state = GameManager.GameState.GUIDE
	
