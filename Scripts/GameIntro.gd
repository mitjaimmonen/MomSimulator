extends Node2D

export var animation_name : String
signal intro_finished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _start():
	print("Playing intro anim")
	get_child(0).play(animation_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	print("intro finished signal")
	emit_signal("intro_finished")
