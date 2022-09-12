extends GameBase

# Accessible vars through inheritance:
# intro_node
# guide_node
# game_node
# outro_node

var game_length : float = 5
var start_time : float = 0


func _ready():
	set_process(false)
	pass


func _play_started():
	start_time = OS.get_unix_time()
	set_process(true)


func _play_finished():
	set_process(false)


func _process(_delta):
	if OS.get_unix_time() - start_time > game_length:
		game_node.play_finished()
	
	

