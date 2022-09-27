extends Node2D

var debug_skip_solution_intro : bool = false
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
	MELONTA,
	NUOTIO,
	TIETOKONE,
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
var resetting : bool = false


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
	print("GameManager Reloading")
	var _er = get_tree().reload_current_scene()
	randomize()
	_solution_state = SolutionState.SPLASH
	_game_state = GameState.NONE
	_current_game = Game.MELONTA
	resetting = true


func scene_loaded():
	if resetting:
		print("GameManager: scene loaded, sending reset signal")	
		emit_signal("reset")
		resetting = false


func quit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
