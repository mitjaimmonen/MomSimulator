extends Node2D

onready var join_node : Label = get_node("UI/Join Label")
onready var welcome_node : Label = get_node("UI/Welcome Label")

var join_timer : float = 0
var ready_timer : float = 0
var players_ready : bool = false
var welcoming_player : bool = false


func _ready():
	set_process_input(false)
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")
	var _er2 = PlayerController.connect("player_joined", self, "_on_player_joined")


func _on_solution_state_changed():
	if GameManager.get_solution_state() == GameManager.SolutionState.LOBBY:
		print("Playing Lobby")
		set_process_input(true)
		set_process(true)
		visible = true
		join_node.visible = true
		welcome_node.visible = false
	else:
		visible = false
		set_process(false)
		set_process_input(false)


func _process(delta):
	join_timer += delta
	ready_timer += delta
	
	if welcoming_player && join_timer > 2:
		join_node.visible = true
		welcome_node.visible = false
		welcoming_player = false
		
	if !players_ready && PlayerController.players_ready():
		players_ready = true
		ready_timer = 0
	elif players_ready && !PlayerController.players_ready():
		players_ready = false
		
	if players_ready and ready_timer > 5:
		GameManager.set_solution_state(GameManager.SolutionState.INTRO)
		PlayerController.set_players_ready(false)


func _on_player_joined(player):
	join_node.visible = false
	welcome_node.visible = true
	welcome_node.text = "Tervetuloa " + player.get_name() + "!!"
	welcoming_player = true
			
	join_timer = 0

