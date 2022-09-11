extends Node2D

signal play_started
signal play_finished

onready var guide_label : Label = get_node("UI/Guide Label")
onready var timer_label : Label = get_node("UI/Timer Label")
var game_time : float

# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.PLAY:
		visible = true
		guide_label.visible = true
		timer_label.visible = true
		game_time = -3
		set_process(true)
	else:
		visible = false
		set_process(false)


func _process(delta):
	game_time += delta
	
	if game_time < 0:
		timer_label.text = int(abs(game_time)) as String
	else:
		timer_label.visible = false
		guide_label.visible = false
		set_process(false)
		emit_signal("play_started")
		# Note that the rest of the game logic will be in the game scene root script,
		# specific to each game



func play_finished():
	emit_signal("play_finished")
