extends Node2D

signal start_signal

func _ready():
	set_process_input(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.MENU:
		print("Playing Menu")
		visible = true
		set_process_input(true)
	else:
		visible = false
		set_process_input(false)

func _input(event):
	var is_gamepad = event is InputEventJoypadButton or event is InputEventJoypadMotion
	if event.is_pressed() && is_gamepad:
		set_process_input(false)
		emit_signal("start_signal")
		GameManager.set_solution_state(GameManager.SolutionState.LOBBY)
		visible = false
