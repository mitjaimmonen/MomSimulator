extends Node2D

signal guide_finished

var players_ready : bool = false
var players_ready_time : float = 0

# Called when the node enters the scene tree for the first time.
func start():
	visible = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		visible = true
		set_process(true)
	else:
		visible = false
		set_process(false)


func _process(delta):
	if !players_ready and PlayerController.players_ready():
		players_ready = true
		players_ready_time = 0
	if players_ready and !PlayerController.players_ready():
		players_ready = false
	
	if players_ready: 
		if players_ready_time > 5:
			finish_state()
		else:
			players_ready_time += delta

func finish_state():
	print("guide finished")
	emit_signal("guide_finished")
