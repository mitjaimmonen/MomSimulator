extends Node2D

signal player_joined(player)

var unused_player_visuals = []
var used_player_visuals = {}
var scene_root
var players = []
var player_controller_ids = []

var unused_player_audio = []
var unused_player_win_audio = []


func _ready():
	_reset()
	var _er1 = GameManager.connect("reset", self, "_reset")
	var _er2 = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _reset():
	print("PlayerController reset!")
	_populate_player_visuals()
	_populate_player_audio()
	_populate_player_win_audio()
	set_process_input(false)
	players.clear()
	player_controller_ids.clear()
	var root = get_tree().root
	scene_root = root.get_child(root.get_child_count() - 1)


func _populate_player_visuals():
	unused_player_visuals.clear()
	used_player_visuals.clear()
	
	var path = "res://Scenes/PrefabScenes/PlayerVisuals/"
	var files = get_files(path)

	for filepath in files:
		unused_player_visuals.append(load(path + filepath))


func _populate_player_win_audio():
	unused_player_win_audio.clear()
	

	var path = "res://Audio/Effects/win/"
	var files = get_files(path)

	for filepath in files:
		unused_player_win_audio.append(load(path + filepath))


func _populate_player_audio():
	unused_player_audio.clear()
	
	var path = "res://Audio/Effects/player/"
	var files = get_files(path)

	for filepath in files:
		unused_player_audio.append(load(path + filepath))


func get_files(path : String) -> PoolStringArray :
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(file)
	
	return files


func _on_solution_state_changed():	
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
	print("New player! Device: ", controller_id, ", ", Input.get_joy_name(controller_id))
	
	var player_instance : PlayerInstance = load("res://Scenes/PrefabScenes/PlayerInstance.tscn").instance()
	scene_root.get_node("Players").add_child(player_instance)
	
	players.append(player_instance)
	player_controller_ids.append(controller_id)

	player_instance.controller_id = controller_id
	player_instance.id = players.size() - 1
	
	if unused_player_visuals.size() == 0:
		_populate_player_visuals()
	
	var visual_index = int(rand_range(0, unused_player_visuals.size()))
	var visual : Node2D = unused_player_visuals[visual_index].instance()
	player_instance.add_child(visual)
	player_instance.move_child(visual, 0)
	used_player_visuals[player_instance.id] = unused_player_visuals[visual_index]
	unused_player_visuals.remove(visual_index);
	
	if unused_player_audio.size() == 0:
		_populate_player_audio()
	if unused_player_win_audio.size() == 0:
		_populate_player_win_audio()
	
	var audio_index = int(rand_range(0, unused_player_audio.size()))
	var win_audio_index = int(rand_range(0, unused_player_win_audio.size()))
	player_instance.audio = unused_player_audio[audio_index] as AudioStream
	player_instance.win_audio = unused_player_win_audio[win_audio_index] as AudioStream
	unused_player_audio.remove(audio_index)
	unused_player_win_audio.remove(win_audio_index)
	
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

func get_current_winner() -> PlayerInstance:
	var winner_id = -1
	for p in players:
		if winner_id == -1 or p.current_points > players[winner_id].current_points:
			winner_id = p.id
	
	return players[winner_id]


func get_winner() -> PlayerInstance:
	var winner_ids = []
	for p in players:
		if winner_ids.size() == 0:
			winner_ids.append(p.id)
		elif p.games_won > players[winner_ids[0]].games_won:
			winner_ids.clear()
			winner_ids.append(p.id)
		elif p.games_won == players[winner_ids[0]].games_won:
			winner_ids.append(p.id)
	
	if winner_ids.size() == 1:
		return players[winner_ids[0]]
	else:
		var points_winner_id = -1
		for id in winner_ids:
			if points_winner_id < 0:
				points_winner_id = id
			elif players[id].total_points > players[points_winner_id].total_points:
				points_winner_id = id
		return players[points_winner_id]
			

