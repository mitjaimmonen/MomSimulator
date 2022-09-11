extends GameBase

# Accessible vars through inheritance:
# intro_node
# guide_node
# game_node
# outro_node


func _ready():
	var _er = game_node.connect("game_started", self, "_on_game_started")
	var _er1 = game_node.connect("game_finished", self, "_on_game_finished")


func _on_game_started():
	set_process(true)


func _on_game_finished():
	set_process(false)


func _process(_delta):
	pass

