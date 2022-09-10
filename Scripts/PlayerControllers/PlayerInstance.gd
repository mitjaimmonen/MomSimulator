extends Node

onready var player_visual = get_node("PlayerVisual")
export var controller_id : int
export var id : int
export var current_points : int
export var total_points : int

var ready : bool = false

func _ready():
#	GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")
#	GameManager.connect("game_state_changed", self, "_on_game_state_changed")
#	GameManager.connect("game_changed", self, "_on_game_changed")
	
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	set_process_input(true)




func _set_ready(var value : bool):
	ready = value

func _get_name():
	return player_visual._get_name()

func _input(event):
	if !event.is_pressed():
		return
		
	if GameManager._get_solution_state() == GameManager.SolutionState.LOBBY:
		if !ready:
			ready = true
	
	if GameManager._get_solution_state() == GameManager.SolutionState.GAME:
		_game_input(event)
		

func _game_input(event):
	if GameManager.game_state == GameManager.GameState.GUIDE :
		# Check for ready here by checking game specific inputs
		pass
	if GameManager.game_state == GameManager.GameState.PLAY :
		# gameplay inputs, specific to the game, how?
		pass
	

func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_id):
		if (is_connected):
			print("phew all good again ", device_id)
		else:
			print ("shit you disconnected! ", device_id)

