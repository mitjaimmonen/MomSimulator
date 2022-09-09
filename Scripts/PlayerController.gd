extends Node2D

export var margin_x : int = 20
export var margin_y : int = 20

var players = []
var player_controller_ids = []


func _ready():
	print("set input")
	set_process_input(true)


func _input(event):
	if (GameManager.solution_state != GameManager.SolutionState.LOBBY) :
		return
		
	var is_action = event.is_pressed()
	var new_device = !player_controller_ids.has(event.device)
	
	if (is_action && new_device):
		_create_player(event.device)


func _create_player(var controller_id : int):
	print("New player! Device: ", controller_id)
	
	var player_instance = load("res://Scenes/PrefabScenes/PlayerInstance.tscn").instance()
	add_child(player_instance)
	
	var viewport_width : int = get_viewport_rect().size.x
	var viewport_height : int = get_viewport_rect().size.y
	
	player_instance.position.x = margin_x + (players.size() * (player_instance.visual_width + margin_x))
	player_instance.position.y = viewport_height - margin_y - player_instance.visual_height
	
	
	players.append(player_instance)
	player_controller_ids.append(controller_id)

	player_instance.controller_id = controller_id
	player_instance.id = players.count(Node2D)
