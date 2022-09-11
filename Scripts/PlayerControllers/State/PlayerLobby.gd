extends Node2D

var player_instance : PlayerInstance

var cancelling_ready : bool = false
var cancel_ready_time : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = get_parent().get_parent() as PlayerInstance
	
	set_process(false)
	set_process_input(false)
	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")
	_on_solution_state_changed()


func _on_solution_state_changed():
	_set_lobby_process()


func _set_lobby_process():
	var is_lobby : bool = GameManager.get_solution_state() == GameManager.SolutionState.LOBBY
	
	if is_lobby:
		print("Player processing started for lobby")
		set_process(true)
		set_process_input(true)
	else:
		set_process(false)
		set_process_input(false)
		
func _process(delta):
	if cancelling_ready:
		if Input.is_action_pressed("start"):
			cancel_ready_time += delta
			if cancel_ready_time > 1:
				player_instance.set_ready(false)
		else:
			cancelling_ready = false

func _input(event):
	if !player_instance.is_ready():
		var correct_id = event.device == player_instance.controller_id
		var is_pressed = event.is_pressed()
		if correct_id && is_pressed:
			print("PlayerLobby setting player ready true")
			player_instance.set_ready(true)
	elif event.is_action_pressed("start"):
			cancelling_ready = true
			cancel_ready_time = 0
