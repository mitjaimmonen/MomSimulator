extends Node2D

onready var splatter_sound : AudioStream = load("res://Audio/Effects/splatter.ogg")
onready var roller_sound : AudioStream = load("res://Audio/Effects/paint-roller.ogg")

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


func play_splatter():
	AudioController.play_effect(splatter_sound)


func play_paint_roller():
	AudioController.play_effect(roller_sound)
