extends Node2D
class_name PlayerGameBase

var game_container : ViewportContainer
var player_instance : PlayerInstance
var game

var cancelling_ready : bool = false
var cancel_ready_time : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = get_parent().get_parent() as PlayerInstance
	
	set_process(false)
	set_process_input(false)
	
	var _game_changed_er = GameManager.connect("game_changed", self, "_on_game_changed")
	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_game_changed():
	_set_game_process()


func _on_solution_state_changed():
	_set_game_process()


func _set_game_process():
	var is_game : bool = GameManager.get_solution_state() == GameManager.SolutionState.GAME
	var correct_game : bool = GameManager.get_game() == game
	
	if is_game and correct_game:
		print("Player processing started for game: ", game)
		game_container = get_tree().get_nodes_in_group("GameContainer")[0] as ViewportContainer
		var _game_er = game_container.get_child(0).get_node("Peli").connect("play_started", self, "_on_play_started")
		var _game_er2 = game_container.get_child(0).get_node("Peli").connect("play_finished", self, "_on_play_finished")
		set_process(true)
		set_process_input(true)
	else:
		set_process(false)
		set_process_input(false)


func _on_play_started():
	game_container.get_child(0).get_node("Peli").disconnect("play_started", self, "_on_play_started")
	_play_started()


func _on_play_finished():
	game_container.get_child(0).get_node("Peli").disconnect("play_finished", self, "_on_play_finished")
	_play_finished()


func _process(delta):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			base_process_guide(delta)
			_process_guide(delta)
		GameManager.GameState.PLAY:
			base_process_gameplay(delta)
			_process_gameplay(delta)


func _input(event):
	match GameManager.get_game_state():
		GameManager.GameState.GUIDE:
			base_process_guide_input(event)
			_process_guide_input(event)
		GameManager.GameState.PLAY:
			base_process_gameplay_input(event)
			_process_gameplay_input(event)


func base_process_guide(delta : float):
	if player_instance.is_ready() && cancelling_ready:
		cancel_ready_time += delta
		if cancel_ready_time > 1:
			print("cancelled player ready")
			player_instance.set_ready(false)
			cancelling_ready = false


func base_process_guide_input(event : InputEvent):
	if event.device != player_instance.controller_id:
		return
	
	if !cancelling_ready:
		if player_instance.is_ready() && event.is_action_pressed("start"):
				cancelling_ready = true
				cancel_ready_time = 0
	else:
		if event.is_action_released("start"):
				cancelling_ready = false
				cancel_ready_time = 0


func base_process_gameplay(_delta):
	# gameplay logic that all games use
	pass
func base_process_gameplay_input(_event):
	# input logic that all games use
	pass


# overrides
func _process_guide(_delta : float):
	pass
func _process_gameplay(_delta : float):
	pass
func _process_guide_input(_event : InputEvent):
	pass
func _process_gameplay_input(_event : InputEvent):
	pass
func _play_started():
	pass
func _play_finished():
	pass
