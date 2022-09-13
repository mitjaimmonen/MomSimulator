extends Node2D

var game_index : int = 0
var game_active : bool = false
onready var viewport = get_node("GameViewport")

func _ready():
	set_process(false)
	visible = false
	var _state_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")
	var _game_er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.GAME:
		game_index = 0
		_start_next_game()


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.FINISH:
		if _has_next_game():
			_start_next_game()
		else:
			GameManager.set_solution_state(GameManager.SolutionState.FINISH)

func _start_next_game():
	if game_active:
		_stop_game()
	
	visible = true
	game_active = true
	
	var game = load(_get_game_res()).instance()
	viewport.add_child(game)
	
	var current_game = GameManager.Game.values()[game_index]
	print("GameController setting game state to none and game to ", GameManager.Game.keys()[current_game])
	GameManager.set_game(current_game)
	game_index += 1


func _stop_game():
	print("GameController: Stopping current game")
	game_active = false
	visible = false
	GameManager.set_game_state(GameManager.GameState.NONE)
	for n in viewport.get_children():
		viewport.remove_child(n)
		n.queue_free()


func _get_game_res() -> String:
	var current_game = GameManager.Game.values()[game_index]
	match current_game:
		GameManager.Game.MELONTA:
			return "res://Scenes/GameScenes/GameMelonta.tscn"
	
	return ""

func _has_next_game() -> bool:
	if GameManager.Game.size() >= game_index:
		return false
	elif _get_game_res() == "":
		return false
	else:
		return true
