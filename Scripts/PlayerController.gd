extends Node2D

var players = []
var player_indices = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("set input")
	set_process_input(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	
	var is_action = event.is_pressed()
	var new_device = !player_indices.has(event.device)
	
	if (is_action && new_device):
		print("New player")
		var player_instance = load("res://Scenes/PrefabScenes/PlayerInstance.tscn").instance()
		add_child(player_instance)
		players.append(player_instance)
		player_indices.append(event.device)
		
		player_instance.controller_index = event.device
