extends Node2D

onready var join_node : Label = get_node("UI/Join Label")
onready var welcome_node : Label = get_node("UI/Welcome Label")

var last_input_time : float = 0
var welcoming_player : bool = false

func _ready():
	set_process_input(false)
	set_process(false)
	visible = false
	var _er = GameManager.connect("solution_state_changed", self, "_on_solution_state_changed")

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


func _process(_delta):
	var input_timer = OS.get_unix_time() - last_input_time
	
	if welcoming_player && input_timer > 2:
		join_node.visible = true
		welcome_node.visible = false
		welcoming_player = false
		
	if input_timer > 5 && PlayerController.players_ready():
		GameManager.set_solution_state(GameManager.SolutionState.INTRO)

func _input(event):
	if PlayerController.player_controller_ids.has(event.device):
		var player = PlayerController.get_player(event.device)
		if !player.ready:
			join_node.visible = false
			welcome_node.visible = true
			welcome_node.text = "Tervetuloa " + player.get_name() + "!!"
			welcoming_player = true
			
		last_input_time = OS.get_unix_time()

