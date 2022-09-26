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
onready var nuotio_sprite : AnimatedSprite = get_node("Peli/GameVisuals/Nuotio") as AnimatedSprite
onready var gameplay_music : AudioStream = load("res://Audio/game-play-action.ogg")
var gameplay_start_time_ms : int = 0
var game_length : float = 18.5
var is_play : bool = false

#outro
onready var finish_label : Label = get_node("Outro/UI/Finish Label")
onready var winner_label : Label = get_node("Outro/UI/Winner Label")
onready var winner_score_label : Label = get_node("Outro/UI/Winner Score Label")
var outro_start_time_ms : int = 0
var is_outro : bool = false
var winner_shown : bool = false



func _ready():
	set_process(true)
	game_node.play_finish_sounds = false 
	nuotio_sprite.playing = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	pass


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		is_guide = true
		var _anim_er = controller_guide_anim.connect("animation_finished", self, "_on_animation_finished")
		controller_guide_anim.play("controller_anim_stick")
	elif is_guide:
		is_guide = false
		controller_guide_anim.disconnect("animation_finished", self, "_on_animation_finished")
	
	if GameManager.get_game_state() == GameManager.GameState.OUTRO:
		is_outro = true
		outro_start_time_ms = Time.get_ticks_msec()
		winner_shown = false
		finish_label.visible = true
		winner_label.visible = false
		winner_score_label.visible = false
	elif is_outro:
		is_outro = false


func _on_animation_finished(_anim_name):
	controller_guide_anim.play("controller_anim_stick")	


func _play_started():
	gameplay_start_time_ms = Time.get_ticks_msec()
	nuotio_sprite.playing = true
	is_play = true
	AudioController.start_music(gameplay_music, 0)

func _play_finished():
	AudioController.stop_music(3)
	is_play = false	


func _process(_delta):
	
	if is_play:
		var elapsed_time_ms = Time.get_ticks_msec() - gameplay_start_time_ms
		var elapsed_time = float(elapsed_time_ms) / 1000
		
		nuotio_sprite.speed_scale = 0.5 + (elapsed_time / 2.0)
		if elapsed_time > game_length:
			game_node.play_finished()

