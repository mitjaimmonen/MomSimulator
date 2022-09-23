extends Node2D
class_name PlayerInstance

var player_visual
var ready_label
var ranking_label
var points_label

var center_position : Vector2
var intended_position : Vector2
var controller_id : int
var id : int
var current_points : int
var total_points : int

var spawning : bool
var spawn_time_ms : float
var ready : bool = false

var congratulating : bool = false
var congrats_lerp : bool = false
var congrats_time_ms : int = 0


func init():
	player_visual = get_node("PlayerVisual")
	ready_label = get_node("Control/ReadyLabel")
	ranking_label = get_node("Control/RankingLabel")
	points_label = get_node("Control/PointsLabel")
	
	
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
	center_position.x = (viewport_width / 2.0) - ((player_visual.width / 2.0) * scale.x)
	center_position.y = (viewport_height / 2.0) - ((player_visual.height / 2.0) * scale.x)
	
	intended_position.x = id * player_visual.width
	intended_position.y = viewport_height - player_visual.height
	
	position = center_position


func _process(_delta):
	if spawning:
		var time : float = (Time.get_ticks_msec() - spawn_time_ms) / 1000.0 
		if time < 1:
			pass
		elif time < 1.5:
			var t : float = (time - 1.0) / 0.5
			var lerp_t : float = t*t * (3.0 - 2.0*t)
			
			position = lerp(center_position, intended_position, lerp_t)
			scale = lerp(Vector2(2,2), Vector2(1,1), lerp_t)
			pass
		else:
			position = intended_position
			scale = Vector2(1,1)
			spawning = false
			
	if congrats_lerp:
		var time : float = (Time.get_ticks_msec() - congrats_time_ms) / 1000.0
		if time < 0.5:
			var t = time / 0.5
			var lerp_t : float = t*t * (3.0 - 2.0*t)
			
			if congratulating:
				position = lerp(intended_position, center_position, lerp_t)
				scale = lerp(Vector2(1,1), Vector2(2,2), lerp_t)
			else:
				position = lerp(center_position, intended_position, lerp_t)
				scale = lerp(Vector2(2,2), Vector2(1,1), lerp_t)
		else:
			congrats_lerp = false
			if congratulating:
				position = center_position
				scale = Vector2(2,2)
			else:
				position = intended_position
				scale = Vector2(1,1)


func set_ready(var value : bool):
	if ready != value:
		print("player ready ", value)
		ready_label.visible = value
		ready = value


func set_current_points(var value : int):
	if current_points != value:
		current_points = value


func count_total_points():
	total_points += current_points
	print("Adding current points to total. player: ", id, "current points: ", current_points, "total now: ", total_points)


func is_ready() -> bool:
	return ready


func get_name():
	return player_visual.get_name()


func update_game_stats():
	var ranking : int = PlayerController.get_rank(id)
	if ranking == 1:
		ranking_label.text = "Eka"
	elif ranking == 2:
		ranking_label.text = "Toka"
	elif ranking == 3:
		ranking_label.text = "Koka"
	else:
		ranking_label.text = "#" + ranking as String
	
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


func start_congratulations():
	print("starting conngratulations")
	enable_game_stats(false)
	congratulating = true
	congrats_lerp = true
	congrats_time_ms = Time.get_ticks_msec()


func end_congratulations():
	print("ending conngratulations")
	congratulating = false
	congrats_lerp = true
	congrats_time_ms = Time.get_ticks_msec()


