extends Node2D

var state_start_time_ms : float = 0

func _ready():
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.FINISH:
		set_process(true)
		state_start_time_ms = Time.get_ticks_msec()
		visible = true
	else:
		visible = false


func _process(_delta):
	var time = (Time.get_ticks_msec() - state_start_time_ms) / 1000.0
	
	if time > 5:
		GameManager.reset_game()
