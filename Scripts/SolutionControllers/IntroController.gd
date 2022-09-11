extends Node2D

onready var animation_player = get_node("AnimationPlayer") 

func _ready():
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.INTRO:
		print("Playing Intro")
		visible = true
		animation_player.play("intro_anim")
	else:
		visible = false
		


func _on_animation_finished(_anim_name):
	GameManager.set_solution_state(GameManager.SolutionState.GAME)
