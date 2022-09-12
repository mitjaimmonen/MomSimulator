extends Node2D
class_name GameBase

export(NodePath) var intro_node = null
export(NodePath) var guide_node = null
export(NodePath) var game_node = null
export(NodePath) var outro_node = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if intro_node == null:
		intro_node = get_node("Intro")
		if intro_node == null:
			printerr("GameBase: intro_node was null!")
		
	if guide_node == null:
		guide_node = get_node("Ohjeistus")
		if guide_node == null:
			printerr("GameBase: guide_node was null!")
		
	if game_node == null:
		game_node = get_node("Peli")
		if game_node == null:
			printerr("GameBase: game_node was null!")
		
	if outro_node == null:
		outro_node = get_node("Outro")
		if outro_node == null:
			printerr("GameBase: outro_node was null!")
		
	intro_node.visible = true
	guide_node.visible = false
	game_node.visible = false
	outro_node.visible = false
	
	intro_node.connect("intro_finished", self, "_on_intro_finished")
	guide_node.connect("guide_finished", self, "_on_guide_finished")
	game_node.connect("play_finished", self, "_on_play_finished")
	outro_node.connect("outro_finished", self, "_on_outro_finished")
	
	game_node.connect("play_started", self, "_on_play_started")
	
	intro_node.start()
	guide_node.start()
	game_node.start()
	outro_node.start()
	
	GameManager.set_game_state(GameManager.GameState.INTRO)
	PlayerController.set_players_ready(false)


func _on_intro_finished():
	GameManager.set_game_state(GameManager.GameState.GUIDE)


func _on_guide_finished():
	GameManager.set_game_state(GameManager.GameState.PLAY)
	PlayerController.set_players_ready(false)
	PlayerController.enable_player_stats(true)


func _on_play_finished():
	GameManager.set_game_state(GameManager.GameState.OUTRO)
	_play_finished()


func _on_outro_finished():
	PlayerController.enable_player_stats(false)
	GameManager.set_game_state(GameManager.GameState.FINISH)


# Additional overrideable event func
func _on_play_started():
	_play_started()

# Overrides

func _play_started():
	pass


func _play_finished():
	pass
