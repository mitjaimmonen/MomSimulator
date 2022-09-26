extends Node2D

onready var anim_player : AnimationPlayer = get_node("AnimationPlayer")
onready var lobby_music : AudioStream = load("res://Audio/intro-calm-edit.ogg")
onready var join_node : Label = get_node("UI/Join Label")
onready var welcome_node : Label = get_node("UI/Welcome Label")

var is_lobby = false
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
		modulate = Color(0,0,0)
		anim_player.play("lobby_anim")
		AudioController.start_music(lobby_music, 2, true)
		set_process_input(true)
		set_process(true)
		visible = true
		join_node.visible = true
		welcome_node.visible = false
		is_lobby = true
	elif is_lobby:
		is_lobby = false
		visible = false
		set_process(false)
		set_process_input(false)
		AudioController.stop_music(0.5)


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

