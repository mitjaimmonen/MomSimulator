extends Node
class_name PlayerInstance

onready var player_visual = get_node("PlayerVisual")
onready var ready_label = get_node("Control/ReadyLabel")
export var controller_id : int
export var id : int
export var current_points : int
export var total_points : int

var spawn_time : float
var ready : bool = false


func set_ready(var value : bool):
	if ready != value:
		print("player ready ", value)
		ready_label.visible = value
		ready = value


func is_ready() -> bool:
	return ready

func get_name():
	return player_visual.get_name()


func _ready():
	var _input_er = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	ready_label.visible = false
	spawn_time = OS.get_unix_time()
	
	set_process_input(false)
	set_process(true)


func _process(_delta):
	if OS.get_unix_time() - spawn_time > 0.1:
		set_process(false)
		set_process_input(true)


func _input(event):
	if event.device != controller_id:
		return
	if !event.is_pressed():
		return
		
	if GameManager.get_solution_state() == GameManager.SolutionState.LOBBY:
		set_ready(true)
	
	if GameManager.get_solution_state() == GameManager.SolutionState.GAME:
		_game_input(event)
		

func _game_input(_event):
	if GameManager.get_game_state() == GameManager.GameState.GUIDE :
		# Check for ready here by checking game specific inputs
		pass
	if GameManager.get_game_state() == GameManager.GameState.PLAY :
		# gameplay inputs, specific to the game, how?
		pass


func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_id):
		if (is_connected):
			print("phew all good again ", device_id)
		else:
			print ("shit you disconnected! ", device_id)

