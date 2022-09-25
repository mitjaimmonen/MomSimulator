extends GameBase

# Accessible vars through inheritance:
# intro_node
# guide_node
# game_node
# outro_node

#guide
onready var controller_guide_anim : AnimationPlayer = get_node("Ohjeistus/ControllerVisual/AnimationPlayer") as AnimationPlayer
var is_guide : bool = false

#gameplay
onready var kayak_sprite : AnimatedSprite = get_node("Peli/GameVisuals/Kayak") as AnimatedSprite
onready var gameplay_music : AudioStream = load("res://Audio/game-play-fast-8bit.ogg")
var gameplay_start_time_ms : int = 0
var game_length : float = 10
var is_play : bool = false


func _ready():
	set_process(true)
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
	gameplay_start_time_ms = Time.get_ticks_msec()
	is_play = true
	AudioController.start_music(gameplay_music, 0.5)


func _play_finished():
	AudioController.stop_music(0.5)
	is_play = false


func _process(_delta):
	
	if is_play:
		var elapsed_time_ms = Time.get_ticks_msec() - gameplay_start_time_ms
		var elapsed_time = float(elapsed_time_ms) / 1000
		
		if elapsed_time > game_length:
			game_node.play_finished()

