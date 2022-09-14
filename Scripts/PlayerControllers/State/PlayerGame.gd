extends Node2D

var player_instance : PlayerInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = get_parent().get_parent() as PlayerInstance
	set_process(false)
	set_process_input(false)
#	var _solution_state_changed_er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")
#	_on_solution_state_changed()
#
#
#func _on_solution_state_changed():
#	var is_game : bool = GameManager.get_solution_state() == GameManager.SolutionState.GAME
#
#	if is_game:
#		print("Player processing started for game")
#		set_process(true)
#		set_process_input(true)
#	else:
#		set_process(false)
#		set_process_input(false)
#
#
#func _process(delta):
#	pass
#
#func _input(event):
#	pass
