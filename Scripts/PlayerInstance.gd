extends Node

export var visual_width : int = 128
export var visual_height : int = 128

export var controller_id : int
export var id : int

export var current_points : int
export var total_points : int



func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	set_process_input(true)
	

func _input(event):
	pass
	
func _on_joy_connection_changed(device_id, is_connected):
	if (device_id == controller_id):
		if (is_connected):
			print("phew all good again ", device_id)
		else:
			print ("shit you disconnected! ", device_id)

