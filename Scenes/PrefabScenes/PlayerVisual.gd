extends Node2D

export var default_anim : String
export var spawn_anim : String

onready var animation_player = get_node("AnimationPlayer") 


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play(spawn_anim)


func _on_animation_finished(anim_name):
	animation_player.play(default_anim)

