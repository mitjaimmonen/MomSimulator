extends PlayerGameBase

var ready_left_pressed = false
var ready_right_pressed = false
var debug : bool = false

func _ready():
	game = GameManager.Game.MELONTA


func _process_guide(_delta):
	if !debug:
		debug = true
		print("PlayerMelonta processing")
		
	if !player_instance.is_ready():
		if Input.is_action_pressed("left_bumper"):
			ready_left_pressed = true
			
		if Input.get_action_strength("left_trigger") > 0.5:
			ready_left_pressed = true
			
		if Input.is_action_pressed("right_bumper"):
			ready_right_pressed = true
			
		if Input.get_action_strength("right_trigger") > 0.5:
			ready_right_pressed = true
			
		if ready_left_pressed and ready_right_pressed:
			player_instance.set_ready(true)



