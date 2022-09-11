extends PlayerGameBase

func _ready():
	game = GameManager.Game.NUOTIO

func _process(_delta):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			_process_guide()
		GameManager.GameState.PLAY:
			_process_gameplay()
	pass

func _input(_event):
	pass
	
func _process_guide():
	# check if player is ready
	pass

func _process_gameplay():
	# check for game conditions and mechanics, points etc
	pass
