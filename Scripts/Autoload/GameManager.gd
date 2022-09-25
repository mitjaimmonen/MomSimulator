extends Node2D

var debug_skip_solution_intro : bool = true
var debug_skip_game_intro : bool = false

enum SolutionState {
	SPLASH,
	MENU,
	LOBBY,
	INTRO,
	GAME,
	FINISH,
}
enum GameState {
	NONE,
	INTRO,
	GUIDE,
	PLAY,
	OUTRO,
	FINISH,
}
enum Game {
	NUOTIO,
	TIETOKONE,
	MELONTA,
	SANOMALEHTI,
	KEPPI,
	MITJA_TALOSSA,
}

signal reset
signal solution_state_changed
signal game_state_changed
signal game_changed

var _solution_state = SolutionState.SPLASH
var _game_state = GameState.NONE
var _current_game = Game.MELONTA


func _ready():
	randomize()


func get_solution_state() :
	return _solution_state


func get_game_state() :
	return _game_state


func get_game() :
	return _current_game


func set_solution_state(new_state):
	if new_state != _solution_state:
		_solution_state = new_state
		if _solution_state == SolutionState.MENU:
			print("Resetting game")
			reset_game()
		print("Solution State: ", SolutionState.keys()[new_state])
		emit_signal("solution_state_changed")


func set_game_state(new_state):
	if new_state != _game_state:
		_game_state = new_state
		print("Game State: ", GameState.keys()[new_state])
		emit_signal("game_state_changed")

		
func set_game(new_game):
	if new_game != _current_game:
		_current_game = new_game
		print("Game: ", Game.keys()[new_game])
		emit_signal("game_changed")


func reset_game():
	get_tree().reload_current_scene()
	randomize()
	_solution_state = SolutionState.SPLASH
	_game_state = GameState.NONE
	_current_game = Game.MELONTA
	emit_signal("reset")


func quit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
