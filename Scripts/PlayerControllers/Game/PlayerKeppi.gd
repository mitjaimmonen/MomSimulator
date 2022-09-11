extends PlayerGameBase

func _ready():
	game = GameManager.Game.KEPPI

func _process(delta):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			_process_guide(delta)
		GameManager.GameState.PLAY:
			_process_gameplay(delta)
	pass

func _input(_event):
	pass
	
func _process_guide(_delta):
	# check if player is ready
	pass

func _process_gameplay(_delta):
	# check for game conditions and mechanics, points etc
	pass
