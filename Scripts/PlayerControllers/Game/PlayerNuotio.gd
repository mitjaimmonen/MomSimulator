extends PlayerGameBase

# guide / ready
var ready_stick_directions = []

# gameplay
var in_game_last_stick_directions = []
var array_index : int = 0
var is_playing : bool = false
var time_ms : int = 0
var current_points : float = 0
var current_combo_points : float = 0.0
var last_stick_dir : String = ""
var last_stick_max_val : float = 0.0
var is_combo : bool = false


func _ready():
	game = GameManager.Game.NUOTIO


func _play_started():
	print("PlayerNuotio: play started")
	is_playing = true
	is_combo = false
	current_points = 0
	current_combo_points = 0
	player_instance.set_current_points(int(round(current_points)))
	player_instance.update_game_stats()


func _play_finished():
	print("PlayerNuotio: play finished")
	is_playing = false
	if is_combo:
		stop_combo()
		
	player_instance.set_current_points(int(round(current_points)))
	player_instance.count_total_points()
	player_instance.update_game_stats()


func _process_guide(_delta):
	if !player_instance.is_ready():
		if ready_stick_directions.size() == 4:
			player_instance.set_ready(true)


func _process_guide_input(event : InputEvent):
	if event.device != player_instance.controller_id:
		return
	
	if !player_instance.is_ready():
		if !ready_stick_directions.has("left_stick_down") and event.get_action_strength("left_stick_down") > 0.5:
			ready_stick_directions.append("left_stick_down")

		if !ready_stick_directions.has("left_stick_up") and event.get_action_strength("left_stick_up") > 0.5:
			ready_stick_directions.append("left_stick_up")

		if !ready_stick_directions.has("left_stick_left") and event.get_action_strength("left_stick_left") > 0.5:
			ready_stick_directions.append("left_stick_left")

		if !ready_stick_directions.has("left_stick_right") and event.get_action_strength("left_stick_right") > 0.5:
			ready_stick_directions.append("left_stick_right")


func _process_gameplay(_delta):
	if !is_playing:
		return
		
	time_ms = Time.get_ticks_msec()
	
	player_instance.set_current_points(int(round(current_points + current_combo_points)))
	player_instance.update_game_stats()


func _process_gameplay_input(event):
	if !is_playing:
		return
		
	if event.device != player_instance.controller_id:
		return
		
	var down : float = event.get_action_strength("left_stick_down")
	var up : float = event.get_action_strength("left_stick_up")
	var left : float = event.get_action_strength("left_stick_left")
	var right : float = event.get_action_strength("left_stick_right")
	
	if down > 0.2 and down > left and down > right:
		check_direction(down, "left_stick_down")
		
	if up > 0.2 and up > left and up > right:
		check_direction(up, "left_stick_up")
		
	if left > 0.2 and left > up and left > down:
		check_direction(left, "left_stick_left")
		
	if right > 0.2 and right > up and right > down:
		check_direction(right, "left_stick_right")


func check_direction(dir_value: float, dir_action : String):
	if in_game_last_stick_directions.has(dir_action):
		in_game_last_stick_directions.clear()
		stop_combo()
		
	if last_stick_dir == dir_action:
		last_stick_max_val = max(last_stick_max_val, dir_value)
	else: # new dir started
		if last_stick_dir != "":
			in_game_last_stick_directions.append(last_stick_dir)
		if in_game_last_stick_directions.size() > 2:
			in_game_last_stick_directions.remove(0)
			
		last_stick_dir = dir_action
		last_stick_max_val = dir_value
		
		if is_combo:
			current_combo_points += last_stick_max_val + (current_combo_points * 0.1)
		else:
			start_combo()


func stop_combo():
	if is_combo:
		current_points += current_combo_points
		is_combo = false
		current_combo_points = 0


func start_combo():	
	if !is_combo:
		is_combo = true
		current_combo_points = 0

