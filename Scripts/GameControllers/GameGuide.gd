extends Node2D

signal guide_finished



# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		visible = true


func all_players_ready():
	emit_signal("guide_finished")
