extends GameBase

# Accessible vars through inheritance:
# intro_node
# guide_node
# game_node
# outro_node
onready var kayak_sprite : AnimatedSprite = get_node("Peli/GameVisuals/Kayak") as AnimatedSprite
onready var controller_guide_anim : AnimationPlayer = get_node("Ohjeistus/ControllerVisual/AnimationPlayer") as AnimationPlayer

var is_guide : bool = false
var game_length : float = 10
var start_time : float = 0


func _ready():
	set_process(false)
	kayak_sprite.playing = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	pass


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		is_guide = true
		var _anim_er = controller_guide_anim.connect("animation_finished", self, "_on_animation_finished")
		controller_guide_anim.play("controller_anim_rb_lb")
	elif is_guide:
		is_guide = false
		controller_guide_anim.disconnect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(_anim_name):
	controller_guide_anim.play("controller_anim_rb_lb")	


func _play_started():
	start_time = OS.get_unix_time()
	kayak_sprite.playing = true
	set_process(true)


func _play_finished():
	set_process(false)


func _process(_delta):
	var time = OS.get_unix_time() - start_time
	
	kayak_sprite.speed_scale = 0.5 + (time / 2.0)
	
	if time > game_length:
		game_node.play_finished()
	
	

