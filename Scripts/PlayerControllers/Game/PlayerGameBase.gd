extends Node2D
class_name PlayerGameBase

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_process_input(false)
	var _game_changed_er = GameManager.connect("game_changed", self, "_on_game_changed")
	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _on_game_changed():
	_set_game_process()
	
func _on_solution_state_changed():
	_set_game_process()


func _set_game_process():
	var is_game : bool = GameManager._get_solution_state() == GameManager.SolutionState.GAME
	var correct_game : bool = GameManager._get_game() == game
	
	if is_game && correct_game:
		set_process(true)
		set_process_input(true)
	else:
		set_process(false)
		set_process_input(false)

func _process(delta):
	pass

func _input(event):
	pass
