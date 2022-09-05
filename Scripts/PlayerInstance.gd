extends Node

export var controller_index : int
var lobby_player : ViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	set_process_input(true)
	

func _input(event):
	pass
	
func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_index):
		if (is_connected):
			print("phew all good again")
		else:
			print ("shit you disconnected!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
