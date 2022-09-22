extends Node2D

var width : int = 128
var height : int = 128

export var player_name : String
export var default_anim : String
export var spawn_anim : String

onready var animation_player = get_node("AnimationPlayer") 


# Called when the node enters the scene tree for the first time.
func play_spawn_anim():
	if animation_player.has_animation(spawn_anim):
		animation_player.play(spawn_anim)

func get_name():
	return player_name

func _on_animation_finished(_anim_name):
	if animation_player.has_animation(default_anim):
		animation_player.play(default_anim)

