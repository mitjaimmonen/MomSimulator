extends Node

var sfx_player : AudioStreamPlayer
var music_player : AudioStreamPlayer
var scene_root
var default_music_volume

var stopping_music : bool = false
var crossing_music : bool = false
var stopped_music : bool = false
var fade_start_time_ms : int = 0
var fade_duration : float = 0
var next_music : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	scene_root = root.get_child(root.get_child_count() - 1)
	var audio_node = scene_root.get_node("Audio")
	sfx_player = audio_node.get_node("SfxPlayer")
	music_player = audio_node.get_node("MusicPlayer")
	default_music_volume = music_player.volume_db 
	set_process(true)


func _process(_delta):
	if crossing_music:
		var time = Time.get_ticks_msec() - fade_start_time_ms
		if time < fade_duration * 0.5:
			music_player.volume_db = lerp(default_music_volume,-80, (time / fade_duration) * 2)
		elif time < fade_duration:
			if !stopped_music:
				music_player.stop()
				stopped_music = true
				music_player.stream = next_music
				music_player.volume_db = -80
				music_player.play()
			else:
				var lerp_t = (fade_duration * 0.5) - (time / fade_duration) * 2
				music_player.volume_db = lerp(-80,default_music_volume, lerp_t)
		else:
			music_player.volume_db = default_music_volume
			stopped_music = false
			crossing_music = false
	
	if stopping_music:
		var time = Time.get_ticks_msec() - fade_start_time_ms
		if time < fade_duration:
			music_player.volume_db = lerp(default_music_volume,-80, time / fade_duration)
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
