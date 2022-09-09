extends Node2D

enum SolutionState {
	SPLASH,
	MENU,
	LOBBY,
	GAME,
	FINISH
}
enum GameState {
	INTRO,
	GUIDE,
	START,
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

# signal players_ready

var solution_state = SolutionState.SPLASH
var game_state = GameState.INTRO
var current_game = Game.NONE



# Called when the node enters the scene tree for the first time.
func _ready():
	print("GameManager Ready")
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	match solution_state:
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
