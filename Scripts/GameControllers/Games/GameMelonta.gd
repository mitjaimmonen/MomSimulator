extends GameBase

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")

# Process only runs when game exists (when game is active)
func _process(_delta):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			pass
		GameManager.GameState.PLAY:
			# Process actual gameplay
			pass

func _on_game_state_changed():
	print("GameMelonta game state changed: ", GameManager.get_game_state())
	pass
