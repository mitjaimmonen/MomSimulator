extends Node2D
class_name PlayerInstance

enum ControllerLayout {
	full,
	limited,
}

onready var player_visual = get_node("PlayerVisual")
onready var ready_label = get_node("Control/ReadyLabel")
onready var ranking_label = get_node("Control/RankingLabel")
onready var points_label = get_node("Control/PointsLabel")

var spawn_position : Vector2
var intended_position : Vector2
var controller_layout = ControllerLayout.full
var controller_id : int
var id : int
var current_points : int
var total_points : int

var spawning : bool
var spawn_time_ms : float
var ready : bool = false


func init():
	var _input_er = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	points_label.visible = false
	ready_label.visible = false
	ranking_label.visible = false
	set_process(true)
	_start_spawn()


func _start_spawn():
	player_visual.play_spawn_anim()
	spawn_time_ms = Time.get_ticks_msec()
	spawning = true
	
	scale = Vector2(2,2)
	
	var viewport_width = int(get_viewport_rect().size.x)
	var viewport_height = int(get_viewport_rect().size.y)
	spawn_position.x = (viewport_width / 2.0) - ((player_visual.width / 2.0) * scale.x)
	spawn_position.y = (viewport_height / 2.0) - ((player_visual.height / 2.0) * scale.x)
	
	intended_position.x = id * player_visual.width
	intended_position.y = viewport_height - player_visual.height
	
	position = spawn_position


func _process(_delta):
	if spawning:
		var time : float = (Time.get_ticks_msec() - spawn_time_ms) / 1000.0 
		if time < 1:
			pass
		elif time < 1.5:
			var t : float = (time - 1.0) / 0.5
			var lerp_t : float = t*t * (3.0 - 2.0*t)
			
			position = lerp(spawn_position, intended_position, lerp_t)
			scale = lerp(Vector2(2,2), Vector2(1,1), lerp_t)
			pass
		else:
			position = intended_position
			scale = Vector2(1,1)
			spawning = false

func set_ready(var value : bool):
	if ready != value:
		print("player ready ", value)
		ready_label.visible = value
		ready = value


func set_current_points(var value : int):
	if current_points != value:
		current_points = value

func is_ready() -> bool:
	return ready


func get_name():
	return player_visual.get_name()


func update_game_stats():
	var ranking : int = PlayerController.get_rank(id)
	if ranking == 1:
		ranking_label.text = "EKA"
	else:
		ranking_label.text = ranking as String + "."
	
	points_label.text = current_points as String


func enable_game_stats(state: bool):
	ranking_label.visible = state
	points_label.visible = state
	points_label.text = ""
	ranking_label.text = ""



func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_id):
		if (is_connected):
			print("phew all good again ", device_id)
		else:
			print ("shit you disconnected! ", device_id)

