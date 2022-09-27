extends Node2D

onready var animation_player = get_node("AnimationPlayer") 
onready var intro_music : AudioStream = load("res://Audio/intro-combined.ogg")

func _ready():
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.INTRO:
		if GameManager.debug_skip_solution_intro:
			print("IntroController: skipping intro")
			_on_animation_finished("")
			return
		
		print("Playing Intro")
		visible = true
		animation_player.play("intro_anim")
	else:
		visible = false
		

func play_intro_audio():
	AudioController.start_music(intro_music, 0)


func stop_intro_audio():
	AudioController.stop_music(1.0)


func play_intro_sfx(name : String):
	AudioController.play_effect(load("res://Audio/Effects/intro/" + name + ".ogg"))

func _on_animation_finished(_anim_name):
	GameManager.set_solution_state(GameManager.SolutionState.GAME)
