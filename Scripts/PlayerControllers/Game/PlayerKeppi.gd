extends PlayerGameBase

# gameplay
var stick_appear_time_ns : int = 0
var button_press_time_ns : int = 0
var reacted : bool = false
var processed_points : bool = false
var is_playing : bool = false
var time_ms : int = 0


func _ready():
	game = GameManager.Game.KEPPI


func _play_started():
	print("PlayerKeppi: play started")
	is_playing = true
	player_instance.set_current_points(0)
	player_instance.update_game_stats()
	var _er = game_container.get_child(0).connect("stick_appeared", self, "on_stick_appeared")

func _play_finished():
	print("PlayerKeppi: play finished")
	is_playing = false
	player_instance.count_total_points()
	player_instance.update_game_stats()


func _process_guide(_delta):
	pass


func _process_guide_input(event : InputEvent):
	if event.device != player_instance.controller_id:
		return
	
	if !player_instance.is_ready():
		if event.is_pressed():
			player_instance.set_ready(true)


func _process_gameplay(_delta):
	if !is_playing:
		return
	
	if reacted and not processed_points:
		var time = float(button_press_time_ns - stick_appear_time_ns) / 1000000
		var points = abs(5.0 - time) * (5.0 - time) * 100
		player_instance.set_current_points(points)
		player_instance.update_game_stats()
		processed_points = true


func _process_gameplay_input(event: InputEvent):
	if !is_playing:
		return
		
	if event.device != player_instance.controller_id:
		return
		
	if stick_appear_time_ns != 0 and not reacted:
		if event.is_pressed():
			button_press_time_ns = Time.get_ticks_usec()
			AudioController.play_effect(player_instance.audio, 0.4)
			reacted = true


func on_stick_appeared():
	Input.start_joy_vibration(player_instance.controller_id, 1.0, 1.0, 0.25)
	stick_appear_time_ns = Time.get_ticks_usec()




