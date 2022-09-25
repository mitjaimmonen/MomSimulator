extends Node2D

signal play_started
signal play_finished

var play_countdown_sounds = true
var play_finish_sounds = true

onready var countdown_ready_sound : AudioStream = load("res://Audio/Effects/countdown-ready.ogg")
onready var countdown_start_sound : AudioStream = load("res://Audio/Effects/countdown-start.ogg")
onready var game_finish_sound : AudioStream = load("res://Audio/Effects/whistle.ogg")

onready var dim_panel : Panel = get_node("UI/Dim Panel")
onready var guide_label : Label = get_node("UI/Guide Label")
onready var timer_label : Label = get_node("UI/Timer Label")

var game_time : float
var started : bool = false
var countdown_phase : int = 0

# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.PLAY:
		visible = true
		timer_label.text = ""
		guide_label.visible = true
		timer_label.visible = true
		dim_panel.visible = true
		game_time = -3.5
		set_process(true)
	else:
		visible = false
		set_process(false)


func _process(delta):
	game_time += delta
	
	if game_time > -3 and countdown_phase == 0:
		countdown_phase += 1
		timer_label.text = "n"
		if play_countdown_sounds:
			AudioController.play_effect(countdown_ready_sound)
	elif game_time > -2 and countdown_phase == 1:
		countdown_phase += 1
		timer_label.text = "y"
		if play_countdown_sounds:
			AudioController.play_effect(countdown_ready_sound)
	elif game_time > -1 and countdown_phase == 2:
		countdown_phase += 1
		timer_label.text = "t"
		if play_countdown_sounds:
			AudioController.play_effect(countdown_ready_sound)
	elif game_time > 0 and countdown_phase == 3:
		countdown_phase += 1
		timer_label.text = "nyt"
		guide_label.visible = false
		dim_panel.visible = false
		if play_countdown_sounds:
			AudioController.play_effect(countdown_start_sound)
		started = true
		emit_signal("play_started")
	elif game_time > 1:
		timer_label.visible = false
		set_process(false)



func play_finished():
	if play_finish_sounds:
		AudioController.play_effect(game_finish_sound)
	emit_signal("play_finished")
