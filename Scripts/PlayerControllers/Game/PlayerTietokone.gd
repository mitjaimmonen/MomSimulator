extends PlayerGameBase

# guide / ready
var ready_buttons_pressed = []
var in_game_buttons_pressed = {}

# gameplay
var is_playing : bool = false
var time_ms : int = 0
var current_points : int = 0

enum ActionNames {
	left_bumper,
	right_bumper,
	left_trigger,
	right_trigger,
	up,
	down,
	left,
	right,
	north,
	south,
	west,
	east,
	start,
	select,
	left_stick,
	right_stick,
}


func _ready():
	game = GameManager.Game.TIETOKONE


func _play_started():
	print("PlayerTietokone: play started")
	is_playing = true


func _play_finished():
	print("PlayerTietokone: play finished")
	is_playing = false
	
	# TODO
#	player_instance.set_game_stats(1,current_points, current_combo_points, combo_mul)


func _process_guide(_delta):
	if !player_instance.is_ready():
		if ready_buttons_pressed.size() > 3:
			player_instance.set_ready(true)
			ready_buttons_pressed.clear()


func _process_guide_input(event : InputEvent):
	if event.device != player_instance.controller_id:
		return
	
	if !player_instance.is_ready():
		for action in ActionNames.keys():
			if !ready_buttons_pressed.has(action) and event.is_action_pressed(action):
				print("Added action to ready-map: ", action)
				ready_buttons_pressed.append(action)


func _process_gameplay(_delta):
	if !is_playing:
		return
		
	time_ms = Time.get_ticks_msec()
	# TODO
#	player_instance.set_game_stats(1,current_points, current_combo_points, combo_mul)


func _process_gameplay_input(event):
	if !is_playing:
		return
		
	if event.device != player_instance.controller_id:
		return
		

