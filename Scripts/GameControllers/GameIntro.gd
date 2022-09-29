extends Node2D

onready var audio_intro = load("res://Audio/game-intro-jazz.ogg")
export var animation_name : String
signal intro_finished

var running : bool = false


# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	var _anim_er = get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")
	

func _on_game_state_changed():
	if !running and GameManager.get_game_state() == GameManager.GameState.INTRO:
		running = true
		visible = true
		
		if GameManager.skip_game_intro:
			print("GameIntro: skipping intro")
			_on_animation_finished("")
			return
			
		get_node("AnimationPlayer").play(animation_name)
		AudioController.start_music(audio_intro, 0.5)
		print("GameIntro: starting animation: ", animation_name)
		
	elif GameManager.get_game_state() != GameManager.GameState.INTRO:
		visible = false
		running = false


func _on_animation_finished(_anim_name):
	if running:
		running = false
		visible = false
		AudioController.stop_music(1.0)
		emit_signal("intro_finished")
