extends Node

var sfx_player : AudioStreamPlayer
var music_player : AudioStreamPlayer
var scene_root
var default_music_volume

var stopping_music : bool = false
var crossing_music : bool = false
var crossing_phase : int = 0
var stopped_music : bool = false
var fade_start_time_ms : int = 0
var fade_duration : float = 0
var next_music : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	var _er = GameManager.connect("reset", self, "_reset")
	_reset()


func _reset():
	var root = get_tree().root
	scene_root = root.get_child(root.get_child_count() - 1)
	var audio_node = scene_root.get_node("Audio")
	sfx_player = audio_node.get_node("SfxPlayer")
	music_player = audio_node.get_node("MusicPlayer")
	default_music_volume = music_player.volume_db 
	set_process(true)


func _process(_delta):
	if crossing_music:
		var time = float(Time.get_ticks_msec() - fade_start_time_ms) / 1000
		if time < fade_duration * 0.5:
			var t = time / (fade_duration * 0.5)
			var lerp_t = t * t
			music_player.volume_db = lerp(default_music_volume,-24,lerp_t)
		elif time < fade_duration:
			if crossing_phase == 0:
				crossing_phase = 1
				music_player.stop()
				music_player.stream = next_music
				music_player.volume_db = -24
				music_player.play()
			else:
				var t = (time - (fade_duration * 0.5)) / (fade_duration * 0.5)
				var lerp_t = sin(t * PI * 0.5);
				music_player.volume_db = lerp(-24,default_music_volume, lerp_t)
		else:
			music_player.volume_db = default_music_volume
			stopped_music = false
			crossing_music = false
	
	if stopping_music:
		var time = float(Time.get_ticks_msec() - fade_start_time_ms) / 1000
		if time < fade_duration:
			var t = time / fade_duration
			var lerp_t = t * t
			music_player.volume_db = lerp(default_music_volume,-24, lerp_t)
		else:
			music_player.stop()
			stopped_music = true
			stopping_music = false
		pass



func start_music(audio_stream : AudioStream, crossfade : float):
	if crossfade == 0:
		music_player.stop()
		music_player.stream = audio_stream
		music_player.play()
		stopped_music = false
	else:
		crossing_music = true
		crossing_phase = 0
		fade_start_time_ms = Time.get_ticks_msec()
		fade_duration = crossfade
		next_music = audio_stream


func stop_music(fade : float):
	if fade == 0:
		music_player.stop()
		next_music = null
		stopped_music = true
	else:
		stopping_music = true
		fade_start_time_ms = Time.get_ticks_msec()
		fade_duration = fade
