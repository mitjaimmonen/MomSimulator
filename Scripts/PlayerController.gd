extends Node2D

var players = []
var player_controller_ids = []


func _ready():
	print("set input")
	set_process_input(true)


func _input(event):
	var is_action = event.is_pressed()
	var new_device = !player_controller_ids.has(event.device)
	
	if (is_action && new_device):
		_create_player(event.device)


func _create_player(var controller_id : int):
	print("New player! Device: ", controller_id)
	
	var player_instance = load("res://Scenes/PrefabScenes/PlayerInstance.tscn").instance()
	add_child(player_instance)
	
	players.append(player_instance)
	player_controller_ids.append(controller_id)

	player_instance.controller_index = controller_id
	player_instance.controller_id = controller_id
	player_instance.id = players.count()
