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
	WINNER,
	END
}
enum Game {
	NONE,
	MELONTA,
	TIETOKONE,
	RETKILUISTELU,
	SANOMALEHTI,
	KEPPI,
	NUOTIO,
}

signal solution_state_changed
signal game_state_changed
signal game_changed
# signal players_ready

var p_solution_state = SolutionState.SPLASH
var p_game_state = GameState.INTRO
var p_current_game = Game.NONE


func _get_solution_state() :
	return p_solution_state

func _set_solution_state(new_state):
	if new_state != p_solution_state:
		p_solution_state = new_state
		emit_signal("solution_state_changed")

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
