extends Node2D


func _ready():
	if GameManager.get_solution_state() == GameManager.SolutionState.SPLASH:
		visible = true
		print("Playing Splash")
		var player = get_node("AnimationPlayer")
		player.play("SplashAnimation")
	else:
		visible = false



func _on_animation_finished(_anim_name):
	GameManager.set_solution_state(GameManager.SolutionState.MENU)


func _on_menu_start_signal():
	visible = false
