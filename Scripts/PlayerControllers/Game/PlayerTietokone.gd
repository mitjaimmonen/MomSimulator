extends PlayerGameBase

# guide / ready
var ready_buttons_pressed = []

# gameplay
var in_game_buttons_pressed = {}
var is_playing : bool = false
var time_ms : int = 0

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

# Switch single joycon does not have these
enum ActionNamesLimitMask {
	up,
	down,
	left,
	right,
	right_stick,
}


func _ready():
	game = GameManager.Game.TIETOKONE


func _play_started():
	print("PlayerTietokone: play started")
	_populate_action_dictionary()
	is_playing = true
	player_instance.set_current_points(0)
	player_instance.update_game_stats()

func _play_finished():
	print("PlayerTietokone: play finished")
	is_playing = false
	player_instance.set_current_points(_calculate_current_points())
	player_instance.count_total_points()
	player_instance.update_game_stats()

func _populate_action_dictionary():
	for action in ActionNames.keys():
		in_game_buttons_pressed[action] = 0


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
	player_instance.set_current_points(_calculate_current_points())
	player_instance.update_game_stats()

func _process_gameplay_input(event):
	if !is_playing:
		return
		
	if event.device != player_instance.controller_id:
		return
	
	for action in ActionNames.keys():
		if event.is_action_pressed(action):
			in_game_buttons_pressed[action] += 1


func _calculate_current_points() -> int:
	var limited_layout = true
	var multiplier : float = 0
	var base_score = 0
	for key in in_game_buttons_pressed.keys():
		if in_game_buttons_pressed[key] > 0:
			multiplier += 10
			base_score += in_game_buttons_pressed[key]
			if ActionNamesLimitMask.has(key):
				limited_layout = false
	
	if limited_layout:
		var score = base_score * (multiplier / (ActionNames.size() - ActionNamesLimitMask.size()))
		return score
	else:
		var score = base_score * (multiplier / ActionNames.size())
		return score
		
		
		





