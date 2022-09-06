extends Node2D

enum GameState {
	SPLASH,
	MAIN_MENU,
	INTRO,
	GAME_START,
	GAME_MELONTA,
	GAME_TIETOKONE,
	GAME_RETKILUISTELU,
	GAME_SANOMALEHTI,
	GAME_KEPPI,
	GAME_NUOTIO,
}
enum SceneState {
	INTRO,
	GUIDE,
	START,
	GAME,
	WINNER,
	END
}

signal players_ready

var game_state = GameState.SPLASH
var scene_state = SceneState.INTRO

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	match game_state:
		GameState.SPLASH: 
			_process_splash(delta)
		GameState.MAIN_MENU: 
			_process_menu(delta)
		GameState.INTRO: 
			_process_intro(delta)
		GameState.GAME_START: 
			_process_start(delta)
		GameState.GAME_MELONTA: 
			_process_melonta(delta)
		GameState.GAME_TIETOKONE: 
			_process_tietokone(delta)
		GameState.GAME_RETKILUISTELU: 
			_process_retkiluistelu(delta)
		GameState.GAME_SANOMALEHTI: 
			_process_sanomalehti(delta)
		GameState.GAME_KEPPI: 
			_process_keppi(delta)
		GameState.GAME_NUOTIO: 
			_process_nuotio(delta)


func _process_splash(_delta):
	pass

func _process_menu(_delta):
	pass

func _process_intro(_delta):
	pass

func _process_start(_delta):
	pass

func _process_melonta(_delta):
	pass

func _process_tietokone(_delta):
	pass

func _process_retkiluistelu(_delta):
	pass

func _process_sanomalehti(_delta):
	pass

func _process_keppi(_delta):
	pass

func _process_nuotio(_delta):
	pass
