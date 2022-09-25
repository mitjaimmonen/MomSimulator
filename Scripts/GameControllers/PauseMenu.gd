extends Node2D

onready var pause_menu = get_node("Control")
onready var resume_button = get_node("Control/ResumeButton")
onready var reset_button = get_node("Control/ResetButton")
onready var quit_button = get_node("Control/QuitButton")

var controller_id : int = 0
var press_time_ms : int = 0
var pressing_start : bool = false
var paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	set_process_input(true)
	set_process(true)


func _process(_delta):
	if !paused and pressing_start:
		var t = float(Time.get_ticks_msec() - press_time_ms) / 1000
		if t > 2 :
			if GameManager.get_solution_state() != GameManager.SolutionState.GAME:
				pressing_start = false
			elif GameManager.get_game_state() == GameManager.GameState.GUIDE:
				pressing_start = false
			else:
				pause()



func _input(event):
	if GameManager.get_solution_state() != GameManager.SolutionState.GAME:
		return
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		return
	
	if !pressing_start and event.is_action_pressed("start"):
		press_time_ms = Time.get_ticks_msec()
		pressing_start = true
		controller_id = event.device
	if event.device == controller_id and event.is_action_released("start"):
		pressing_start = false
	
	if paused and event.device == controller_id:
		if event.is_action_pressed("south"):
			var focus = pause_menu.get_focus_owner()
			print("pause menu accept. focus: ", focus)
			if focus == resume_button:
				resume()
			elif focus == reset_button:
				reset()
			elif focus == quit_button:
				quit()
			pass
		if event.is_action_pressed("start"):
			resume()

func pause():
	get_tree().paused = true
	pressing_start = false
	paused = true
	visible = true
	resume_button.grab_focus()


func resume():
	get_tree().paused = false
	pressing_start = false
	paused = false
	visible = false


func reset():
	get_tree().paused = false
	paused = false
	GameManager.reset_game()


func quit():
	get_tree().paused = false
	paused = false
	GameManager.quit_game()


