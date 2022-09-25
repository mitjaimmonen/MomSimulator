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
onready var tietokone_sprite : AnimatedSprite = get_node("Peli/GameVisuals/Tietokone") as AnimatedSprite
var game_length : float = 10
var is_play : bool = false
onready var gameplay_music : AudioStream = load("res://Audio/game-play-sus-8bit.ogg")

#outro
onready var finish_label : Label = get_node("Outro/UI/Finish Label")
onready var winner_label : Label = get_node("Outro/UI/Finish Label")
onready var winner_score_label : Label = get_node("Outro/UI/Finish Label")
var is_outro : bool = false
var winner_shown : bool = false



var state_start_time_ms : float = 0


func _ready():
	set_process(true)
	tietokone_sprite.playing = false
	var _er = GameManager.connect("game_state_changed", self, "_on_game_state_changed")
	pass


func _on_game_state_changed():
	if GameManager.get_game_state() == GameManager.GameState.GUIDE:
		is_guide = true
		var _anim_er = controller_guide_anim.connect("animation_finished", self, "_on_animation_finished")
		controller_guide_anim.play("controller_anim_all")
	elif is_guide:
		is_guide = false
		controller_guide_anim.disconnect("animation_finished", self, "_on_animation_finished")
	
	if GameManager.get_game_state() == GameManager.GameState.OUTRO:
		is_outro = true
		state_start_time_ms = Time.get_ticks_msec()
		finish_label.visible = true
		winner_label.visible = false
		winner_score_label.visible = false
	elif is_outro:
		is_outro = false


func _on_animation_finished(_anim_name):
	controller_guide_anim.play("controller_anim_all")


func _play_started():
	state_start_time_ms = Time.get_ticks_msec()
	tietokone_sprite.playing = true
	is_play = true
	AudioController.start_music(gameplay_music, 0.5)


func _play_finished():
	is_play = false
	AudioController.stop_music(0.5)

func _process(_delta):
	var state_time = (Time.get_ticks_msec() - state_start_time_ms) / 1000
	
	if is_play:
		tietokone_sprite.speed_scale = 0.5 + (state_time / 2.0)
		if state_time > game_length:
			game_node.play_finished()

