extends Node

signal music_finished

var sfx_players = []
var music_player : AudioStreamPlayer
var scene_root

#music
var default_music_volume : float = 0
var stopping_music : bool = false
var crossing_music : bool = false
var crossing_phase : int = 0
var stopped_music : bool = false
var fade_start_time_ms : int = 0
var fade_duration : float = 0
var next_music : AudioStream
var looping : bool = false


#sfx
var sfx_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var _er = GameManager.connect("reset", self, "_reset")
	_reset()


func _reset():
	var root = get_tree().root
	scene_root = root.get_child(root.get_child_count() - 1)
	var audio_node = scene_root.get_node("Audio")
	sfx_players.clear()
	for i in range(10):
		var player = AudioStreamPlayer.new()
		player.name = "Sfx" + i as String
		audio_node.add_child(player)
		sfx_players.append(player)
	music_player = audio_node.get_node("MusicPlayer")
	var _er = music_player.connect("finished", self, "on_music_finished")
	default_music_volume = music_player.volume_db 
	set_process(true)


func _process(_delta):
	if crossing_music:
		stopping_music = false
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
			stopped_music = true
			stopping_music = false
			music_player.stop()
		pass



func start_music(audio_stream : AudioStream, crossfade : float, loop : bool = false):
	looping = loop
	
	if crossfade == 0:
		stopping_music = true
		music_player.stop()
		music_player.stream = audio_stream
		music_player.volume_db = default_music_volume
		music_player.play()
		stopped_music = false
		crossing_music = false
		stopping_music = false
	else:
		crossing_music = true
		crossing_phase = 0
		fade_start_time_ms = Time.get_ticks_msec()
		fade_duration = crossfade
		next_music = audio_stream


func stop_music(fade : float):
	if fade == 0:
		next_music = null
		stopped_music = true
		music_player.stop()
	else:
		stopping_music = true
		fade_start_time_ms = Time.get_ticks_msec()
		fade_duration = fade

func play_effect(audio_stream : AudioStream, volume: float = 1.0, pitch : float = 1.0):
	var player = get_available_sfx_player()
	player.stream = audio_stream
	player.pitch_scale = pitch
	player.volume_db = lerp(-24, 0, volume)
	player.play()


func stop_effects():
	for player in sfx_players:
		(player as AudioStreamPlayer).stop()


func get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if !(player as AudioStreamPlayer).playing:
			sfx_index = sfx_players.find(player)
			return player
	sfx_index += 1
	if sfx_index >= sfx_players.size():
		sfx_index = 0
	return sfx_players[sfx_index]


func on_music_finished():
	if looping and !stopped_music and !stopping_music and !crossing_music:
		music_player.play()
	emit_signal("music_finished")
