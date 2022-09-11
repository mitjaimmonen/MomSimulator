extends Node2D

onready var width : int = get_node("Panel").rect_size.x
onready var height : int = get_node("Panel").rect_size.y

export var player_name : String
export var default_anim : String
export var spawn_anim : String

onready var animation_player = get_node("AnimationPlayer") 


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play(spawn_anim)

func _get_name():
	return player_name

func _on_animation_finished(_anim_name):
	animation_player.play(default_anim)

