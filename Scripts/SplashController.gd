extends Node2D


func _ready():
	if GameManager._get_solution_state() == GameManager.SolutionState.SPLASH:
		visible = true
		get_node("AnimationPlayer").play("SplashAnimation")
		print("Playing Splash")
	else:
		visible = false



func _on_animation_finished(anim_name):
	GameManager._set_solution_state(GameManager.SolutionState.MENU)


func _on_menu_start_signal():
	visible = false
