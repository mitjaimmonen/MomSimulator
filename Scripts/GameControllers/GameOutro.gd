extends Node2D

signal outro_finished


# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.OUTRO:
		visible = true
	else:
		visible = false


func outro_finish():
	emit_signal("outro_finished")
