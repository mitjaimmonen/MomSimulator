extends Node2D

var timer : float = 0

func _ready():
	set_process(false)
	visible = false
	GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _process(delta):
	timer += delta
	if timer > 2:
		GameManager._set_solution_state(GameManager.SolutionState.GAME)

func _on_solution_state_changed():
	if GameManager._get_solution_state() == GameManager.SolutionState.INTRO:
		print("Playing Intro")
		visible = true
		timer = 0
		set_process(true)
	else:
		visible = false
		set_process(false)
		
