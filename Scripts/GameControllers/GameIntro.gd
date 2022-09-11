extends Node2D

export var animation_name : String
signal intro_finished

var running : bool = false


# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	

func _on_game_state_changed():
	if !running and GameManager.get_game_state() == GameManager.GameState.INTRO:
		print("Game Intro starting animation")
		running = true
		visible = true
		get_child(0).play(animation_name)


func _on_AnimationPlayer_animation_finished(_anim_name):
	if running:
		running = false
		visible = false
		emit_signal("intro_finished")
