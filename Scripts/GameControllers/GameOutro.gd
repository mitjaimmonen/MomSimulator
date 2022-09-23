extends Node2D

signal outro_finished

onready var finish_label : Label = get_node("UI/Finish Label")
onready var win_label : Label = get_node("UI/Win Label")
onready var player_label : Label = get_node("UI/Player Name Label")
onready var winner_score_label : Label = get_node("UI/Winner Score Label")

var outro_start_time_ms : int = 0
var is_outro : bool = false
var winner_shown : bool = false

# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	set_process(false)
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.OUTRO:
		outro_start_time_ms = Time.get_ticks_msec()
		_populate_labels()
		visible = true
		finish_label.visible = true
		win_label.visible = false
		player_label.visible = false
		winner_score_label.visible = false
		winner_shown = false
		set_process(true)
	else:
		visible = false
		set_process(false)


func _populate_labels():
	# get winner name & points
	pass



func _process(delta):
	var elapsed_time_ms = Time.get_ticks_msec() - outro_start_time_ms
	var elapsed_time = float(elapsed_time_ms) / 1000

	if !winner_shown && elapsed_time > 5:
		# TODO: tell player to go to the center
		winner_shown = true
		finish_label.visible = false
		win_label.visible = true
		player_label.visible = true
		winner_score_label.visible = true
	elif elapsed_time > 10:
		# TODO: tell player to go back
		outro_finish()


func outro_finish():
	emit_signal("outro_finished")
