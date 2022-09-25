extends Node2D

onready var end_card = get_node("UI/End Card")
onready var winner_card = get_node("UI/Winner Card")

onready var player_label = get_node("UI/Winner Card/WinnerName")
onready var points_label = get_node("UI/Winner Card/WinnerPoints")
onready var wins_label = get_node("UI/Winner Card/WinnerWins")

var state_start_time_ms : float = 0

var finish_phase : int = 0

func _ready():
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.FINISH:
		set_process(true)
		state_start_time_ms = Time.get_ticks_msec()
		visible = true
		end_card.visible = true
		winner_card.visible = false
		finish_phase = 0
	else:
		visible = false


func _process(_delta):
	var time = (Time.get_ticks_msec() - state_start_time_ms) / 1000.0
	
	if finish_phase == 0 and time > 5:
		finish_phase = 1
		winner_card.visible = true
		end_card.visible = false
		
		var winner = PlayerController.get_winner()
		winner.start_congratulations()
		
		player_label.text = winner.get_name()
		points_label.text = winner.total_points
		wins_label.text = winner.games_won

	if finish_phase == 1 and time > 15:
		GameManager.reset_game()
