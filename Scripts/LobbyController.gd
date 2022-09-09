extends Node2D

onready var join_node : Label = get_node("UI/Join Label")
onready var welcome_node : Label = get_node("UI/Welcome Label")

func _ready():
	visible = false
	GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

func _on_solution_state_changed():
	if GameManager._get_solution_state() == GameManager.SolutionState.LOBBY:
		visible = true
		join_node.visible = true
		welcome_node.visible = false
	else:
		visible = false


