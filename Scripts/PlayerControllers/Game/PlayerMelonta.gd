extends PlayerGameBase

# guide / ready
var ready_left_pressed = false
var ready_right_pressed = false

# gameplay
var is_playing : bool = false
var time_ms : int = 0

var left_is_pressed = false
var left_was_pressed = false
var right_is_pressed = false
var right_was_pressed = false

var last_accepted_input_time : float = 0
var combo_start_time : float = 0
var is_combo : bool = false
var combo_mul : int = 1
var current_combo_points : int = 0
var current_points : int = 0



func _ready():
	game = GameManager.Game.MELONTA
	


func _play_started():
	print("PlayerMelonta: play started")
	is_playing = true
	is_combo = false
	combo_mul = 1
	current_combo_points = 0
	last_accepted_input_time = 0


func _play_finished():
	print("PlayerMelonta: play finished")
	is_playing = false
	if is_combo:
		stop_combo()
		
	player_instance.set_game_stats(1,current_points, current_combo_points, combo_mul)


func _process_guide(_delta):
	if !player_instance.is_ready():
		if ready_left_pressed and ready_right_pressed:
			player_instance.set_ready(true)
			ready_left_pressed = false
			ready_right_pressed = false


func _process_guide_input(event):
	if event.device != player_instance.controller_id:
		return
	
	if !player_instance.is_ready():
		if event.is_action_pressed("left_bumper"):
			ready_left_pressed = true
			
		if event.get_action_strength("left_trigger") > 0.5:
			ready_left_pressed = true
			
		if event.is_action_pressed("right_bumper"):
			ready_right_pressed = true
			
		if event.get_action_strength("right_trigger") > 0.5:
			ready_right_pressed = true


func _process_gameplay(_delta):
	if !is_playing:
		return
		
	time_ms = Time.get_ticks_msec()
	
	if is_combo:
		combo_mul = 1 + int((time_ms - combo_start_time) / 1000.0)
		
	if is_combo && time_ms - last_accepted_input_time > 250:
		print("Stop combo because of time")
		stop_combo()
	
	player_instance.set_game_stats(1,current_points, current_combo_points, combo_mul)


func _process_gameplay_input(event):
	if !is_playing:
		return
		
	if event.device != player_instance.controller_id:
		return
		
	var left_event = event.is_action_pressed("group_controller_left_side")
	var left_event_release = event.is_action_released("group_controller_left_side")
	var right_event = event.is_action_pressed("group_controller_right_side")
	var right_event_release = event.is_action_released("group_controller_right_side")
	
	if left_event && !left_is_pressed:
		left_is_pressed = true
		left_was_pressed = true
		if right_was_pressed:
			if !is_combo:
				start_combo()
			right_was_pressed = false
			current_combo_points += 1
			last_accepted_input_time = time_ms
		else: # Right was not pressed last time
			print("Stop combo because of Right was not pressed previously")
			stop_combo()

	if left_event_release:
		left_is_pressed = false
	
	if right_event && !right_is_pressed:
		right_is_pressed = true
		right_was_pressed = true
		if left_was_pressed:
			if !is_combo:
				start_combo()
			left_was_pressed = false
			current_combo_points += 1
			last_accepted_input_time = time_ms
		else: # Left was not pressed last time
			print("Stop combo because of Left was not pressed previously")
			stop_combo()
	
	if right_event_release:
		right_is_pressed = false
	

func stop_combo():
	if is_combo:
		current_points += combo_mul * current_combo_points
		player_instance.set_current_points(current_points)
		
		is_combo = false
		combo_mul = 1
		current_combo_points = 0


func start_combo():	
	if !is_combo:
		is_combo = true
		combo_start_time = time_ms
		combo_mul = 1
		current_combo_points = 0





