extends Node
class_name PlayerInstance

signal current_points_changed

onready var player_visual = get_node("PlayerVisual")
onready var ready_label = get_node("Control/ReadyLabel")
onready var ranking_label = get_node("Control/RankingLabel")
onready var points_label = get_node("Control/PointsLabel")
onready var combo_label = get_node("Control/ComboLabel")

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


func set_current_points(var value : int):
	if current_points != value:
		current_points = value
		emit_signal("current_points_changed") # TODO read & update stats

func is_ready() -> bool:
	return ready


func get_name():
	return player_visual.get_name()


func set_game_stats(ranking:int, score:float, combo:int):
	if ranking == 1:
		ranking_label.text = "EKA"
	elif ranking == 2:
		ranking_label.text = "TOKA"
	elif ranking == 3:
		ranking_label.text = "KOLKKI"
	else:
		ranking_label.text = ""
		
	points_label.text = score as String
	combo_label.text = combo as String + "x"


func enable_game_stats(state: bool):
	ranking_label.visible = state
	points_label.visible = state
	combo_label.visible = state


func _ready():
	var _input_er = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	spawn_time = OS.get_unix_time()
	points_label.visible = false
	combo_label.visible = false
	ready_label.visible = false
	ranking_label.visible = false


func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_id):
		if (is_connected):
			print("phew all good again ", device_id)
		else:
			print ("shit you disconnected! ", device_id)

