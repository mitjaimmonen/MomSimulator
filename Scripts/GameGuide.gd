extends Node2D

signal guide_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_state = GameManager.GameState.GUIDE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass