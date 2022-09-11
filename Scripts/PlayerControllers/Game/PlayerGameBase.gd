extends Node2D
class_name PlayerGameBase

var player_instance : PlayerInstance
var game

var cancelling_ready : bool = false
var cancel_ready_time : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = get_parent().get_parent() as PlayerInstance
	
	set_process(false)
	set_process_input(false)
	
	var _game_changed_er = GameManager.connect("game_changed", self, "_on_game_changed")
	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_game_changed():
	_set_game_process()
	
	
func _on_solution_state_changed():
	_set_game_process()


func _set_game_process():
	var is_game : bool = GameManager.get_solution_state() == GameManager.SolutionState.GAME
	var correct_game : bool = GameManager.get_game() == game
	
	if is_game && correct_game:
		print("Player processing started for game: ", game)
		set_process(true)
		set_process_input(true)
	else:
		set_process(false)
		set_process_input(false)


func _process(delta):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			_process_guide(delta)
		GameManager.GameState.PLAY:
			_process_gameplay(delta)


func _input(event):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			_process_guide_input(event)
		GameManager.GameState.PLAY:
			_process_gameplay_input(event)


func _process_guide(delta : float):
	if cancelling_ready:
		if Input.is_action_pressed("start"):
			cancel_ready_time += delta
			if cancel_ready_time > 1:
				player_instance.set_ready(false)
		else:
			cancelling_ready = false


func _process_guide_input(_event : InputEvent):
	if _event.is_action_pressed("start"):
			cancelling_ready = true
			cancel_ready_time = 0


func _process_gameplay(_delta : float):
	pass


func _process_gameplay_input(_event : InputEvent):
	pass
