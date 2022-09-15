extends Node2D

signal player_joined(player)

export var margin_x : int = 20
export var margin_y : int = 20
var scene_root
var players = []
var player_controller_ids = []
var initialized : bool = false


func _ready():
	set_process_input(false)
	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if !initialized:
		var root = get_tree().root
		scene_root = root.get_child(root.get_child_count() - 1)
		initialized = true
	
	if (GameManager.get_solution_state() == GameManager.SolutionState.LOBBY) :
		set_process_input(true)
	else :
		set_process_input(false)


func _input(event):
	var is_action = event.is_pressed()
	var is_gamepad = event is InputEventJoypadButton or event is InputEventJoypadMotion
	var new_device = !player_controller_ids.has(event.device)
	
	if (is_action && new_device && is_gamepad):
		_create_player(event.device)


func _create_player(var controller_id : int):
	print("New player! Device: ", controller_id)
	
	var player_instance : PlayerInstance = load("res://Scenes/PrefabScenes/PlayerInstance.tscn").instance()
	scene_root.get_node("Players").add_child(player_instance)
	
	players.append(player_instance)
	player_controller_ids.append(controller_id)

	player_instance.controller_id = controller_id
	player_instance.id = players.size() - 1
	
	player_instance.init()
	
	emit_signal("player_joined", player_instance)


func get_player(device_id) -> PlayerInstance:
	return players[player_controller_ids.find(device_id)]


func players_ready() -> bool:
	if players.size() == 0:
		return false
	for p in players:
		if !p.ready:
			return false
	return true


func set_players_ready(value):
	for p in players:
		p.set_ready(value)


func enable_player_stats(value : bool):
	for p in players:
		p.enable_game_stats(value)


func get_rank(id: int) -> int:
	var rank : int = 1
	for player in players:
		if players[id] == player:
			continue
		if player.current_points > players[id].current_points:
			rank += 1
	
	return rank


func reset():
	for p in players:
		p.queue_free()
	players.clear()
	player_controller_ids.clear()
	set_process_input(false)
	initialized = false
