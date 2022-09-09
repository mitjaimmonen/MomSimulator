extends Node2D

signal start_signal

func _ready():
	visible = false
	GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _on_solution_state_changed():
	if GameManager._get_solution_state() == GameManager.SolutionState.MENU:
		visible = true
		set_process_input(true)
	else:
		visible = false
		set_process_input(false)

func _input(event):
	if event.is_pressed():
		set_process_input(false)
		emit_signal("start_signal")
		GameManager._set_solution_state(GameManager.SolutionState.LOBBY)
		visible = false
