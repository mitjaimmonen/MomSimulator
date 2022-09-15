extends Node2D

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
		get_node("AnimationPlayer").play(animation_name)
		print("Game Intro starting animation")
	elif GameManager.get_game_state() != GameManager.GameState.INTRO:
		visible = false
		running = false


func _on_animation_finished(_anim_name):
	if running:
		running = false
		visible = false
		emit_signal("intro_finished")
