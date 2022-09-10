extends Node2D

var game_index : int = 0
var game_active : bool = false
onready var viewport = get_node("GameViewport")

func _ready():
	set_process(false)
	visible = false
	GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")


func _on_solution_state_changed():
	if GameManager._get_solution_state() == GameManager.SolutionState.GAME:
		print("Playing Game")
		visible = true
		var game = load(_get_game_res()).instance()
		viewport.add_child(game)
		set_process(true)
		_set_game()
	elif game_active:
		set_process(false)
		game_active = false
		visible = false
		for n in viewport.get_children():
			viewport.remove_child(n)
			n.queue_free()

func _get_game_res():
	var current_game = GameManager.Game.values()[game_index]
	match current_game:
		GameManager.Game.MELONTA:
			return "res://Scenes/GameScenes/GameMelonta.tscn"
	
	return ""

func _set_game():
	var current_game = GameManager.Game.values()[game_index]
	GameManager._set_game(current_game)
