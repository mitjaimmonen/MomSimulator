extends Node2D

enum SolutionState {
	SPLASH,
	MENU,
	LOBBY,
	INTRO,
	GAME,
	FINISH
}
enum GameState {
	INTRO,
	GUIDE,
	PLAY,
	OUTRO
}
enum Game {
	MELONTA,
	TIETOKONE,
	SANOMALEHTI,
	NUOTIO,
	KEPPI,
	MITJA_TALOSSA
}

signal solution_state_changed
signal game_state_changed
signal game_changed
# signal players_ready

var p_solution_state = SolutionState.SPLASH
var p_game_state = GameState.INTRO
var p_current_game = Game.MELONTA


func _get_solution_state() :
	return p_solution_state
func _get_game_state() :
	return p_game_state
func _get_game() :
	return p_current_game

func _set_solution_state(new_state):
	if new_state != p_solution_state:
		p_solution_state = new_state
		emit_signal("solution_state_changed")
		
func _set_game_state(new_state):
	if new_state != p_game_state:
		p_game_state = new_state
		emit_signal("game_state_changed")
		
func _set_game(new_game):
	if new_game != p_current_game:
		p_current_game = new_game
		emit_signal("game_changed")

func _ready():
	_set_solution_state(SolutionState.SPLASH)


func _process(delta):
	match p_solution_state:
		SolutionState.SPLASH: 
			_process_splash(delta)
		SolutionState.MENU: 
			_process_menu(delta)
		SolutionState.GAME: 
			_process_game(delta)
		SolutionState.FINISH: 
			_process_finish(delta)


func _process_splash(_delta):
	pass

func _process_menu(_delta):
	pass

func _process_game(_delta):
	pass

func _process_finish(_delta):
	pass
