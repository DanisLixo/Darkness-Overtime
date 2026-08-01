extends Node

const AUDIO_LIBRARY := {
	"mus": {
		"deluge_approaching": "res://Assets/Audios/BGMs/Tests/mus_delugeApproaching.mp3",
		"enemy_approaching": "res://Assets/Audios/BGMs/Tests/mus_enemyApproaching.mp3",
		"eruption_approaching": "res://Assets/Audios/BGMs/Tests/mus_eruptionApproaching.mp3",
		"special_approaching": "res://Assets/Audios/BGMs/Tests/mus_specialApproaching.mp3",
		"star": "res://Assets/Audios/BGMs/Tests/mus_star.mp3",
		"teabat_credits": "res://Assets/Audios/BGMs/Tests/TeabatCredits.ogg",
		"teabat_shop": "res://Assets/Audios/BGMs/Tests/TeabatShop.ogg",
	},
	"sfx": {
		"rain_ambience": "res://Assets/Audios/SFXs/Ambience/RainAmbienceTest.mp3",
		"rain_step": "res://Assets/Audios/SFXs/RainStepTest.wav",
		"gun_shot": "res://AssetsOld/Audios/SFXs/gun_shot.wav"
	}
}

enum OverrideMusic {NONE = -1, CURRENT = 0, OVERRIDE}

@onready var musicPlayer: AudioStreamPlayer = $Music
@onready var musicOverridePlayer: AudioStreamPlayer = $MusicOverride
var musLibrary := AUDIO_LIBRARY.mus.duplicate(true)
var current_music := ""
signal music_beat(idx)

var overrideMusic: OverrideMusic = OverrideMusic.CURRENT

var sfxLibrary := AUDIO_LIBRARY.sfx.duplicate(true)
var queuedSfxs := []
var activeSfxs := {}

func play_sfx(streamName = "", isAmbience := false, position := Vector2.ZERO, pitch := 1.0, canOverlap := true) -> void:
	if !sfxLibrary.has(streamName):
		printerr("Som nao encontrado na biblioteca.")
		return
		
	if (not canOverlap and activeSfxs.has(streamName)) or queuedSfxs.has(streamName):
		return
	queuedSfxs.append(streamName)
	if streamName is String:
		if activeSfxs.has(streamName):
			activeSfxs[streamName].queue_free()
	var player = AudioStreamPlayer2D.new()
	player.global_position = position
	var stream = streamName
	if streamName is String:
		var stream_path = sfxLibrary[streamName]
		if stream_path is Array:
			stream_path = stream_path.pick_random()
		stream = import_stream(stream_path)
	player.stream = stream
	player.autoplay = true
	player.pitch_scale = pitch
	player.max_distance = 99999
	player.bus = "SFX" if !isAmbience else "Ambience"
	$Sounds.add_child(player)
	activeSfxs[streamName] = player
	queuedSfxs.erase(streamName)
	await player.finished
	activeSfxs.erase(streamName)
	player.queue_free()

func play_global_sfx(streamName = "", isAmbience := false, pitch := 1.0) -> void:
	if get_viewport().get_camera_2d() == null:
		return
	play_sfx(streamName, isAmbience, get_viewport().get_camera_2d().get_screen_center_position(), pitch)

func kill_sfx(sfxName := "") -> void:
	if activeSfxs.has(sfxName):
		activeSfxs[sfxName].queue_free()
		activeSfxs.erase(sfxName)

func play_music(stream_name = "", pitch := 1.0) -> void:
	if (overrideMusic != OverrideMusic.CURRENT):
		return
	
	var _delta_ := get_process_delta_time()
	tween_music_stream(musicPlayer, -80, 20 / _delta_ * 60.0)
	
	await music_tweened
	stop_all_music()
	
	var stream = stream_name
	
	if (stream_name != ""):
		if stream_name is String:
			var stream_path = musLibrary[stream_name]
			stream = import_stream(stream_path)
	
		musicPlayer.stream = stream
	musicPlayer.pitch_scale = pitch
	
	if (stream is AudioStreamSynchronized):
		set_current_used_sync(musicPlayer, 0, 60 / _delta_ * 60.0)
	else:
		tween_music_stream(musicPlayer, 0, 20 / _delta_ * 60.0)
	await music_tweened

func play_override_music(stream_name = "", pitch := 1.0) -> void:
	if (overrideMusic == OverrideMusic.NONE):
		return
	
	overrideMusic = OverrideMusic.OVERRIDE
	
	var _delta_ := get_process_delta_time()
	tween_music_stream(musicPlayer, -80, 20 / _delta_ * 60.0)
	
	await music_tweened
	stop_all_music()
	
	var stream = stream_name
	if stream_name is String:
		var stream_path = musLibrary[stream_name]
		stream = import_stream(stream_path)
	
	musicOverridePlayer.stream = stream
	musicPlayer.pitch_scale = pitch
	
	if (stream is AudioStreamSynchronized):
		set_current_used_sync(musicOverridePlayer, 0, 60 / _delta_ * 60.0)
	else:
		tween_music_stream(musicOverridePlayer, 0, 20 / _delta_ * 60.0)
	
	musicOverridePlayer.finished.connect(stop_override_music)
	await music_tweened

func stop_override_music() -> void:
	musicOverridePlayer.stop()
	
	overrideMusic = OverrideMusic.CURRENT

func stop_all_music() -> void:
	AudioManager.musicPlayer.stop()
	AudioManager.musicOverridePlayer.stop()

func set_current_used_sync(streamer: AudioStreamPlayer, id := 0, stepDec := 0.0, stepInc := 0.0, muteOthers := true) -> void:
	if (musicPlayer.stream is not AudioStreamSynchronized):
		return
	
	var stream: AudioStreamSynchronized = streamer.stream
	
	for i in stream.stream_count:
		if (i != id && muteOthers):
			tween_sync_music_stream(streamer, i, -60, stepDec)
		else:
			tween_sync_music_stream(streamer, i, 0, stepInc)

signal music_tweened
var running_tweening := false
func tween_music_stream(streamer: AudioStreamPlayer, target_db: float = 0, step: float = 1.0) -> void:
	if (running_tweening):
		return
	
	running_tweening = true
	var curVolume: float = streamer.volume_db
	var goUpwards = curVolume < target_db
	
	while curVolume != target_db:
		curVolume = streamer.volume_db
		if (goUpwards && target_db > curVolume) || (!goUpwards && target_db < curVolume):
			streamer.volume_db = move_toward(streamer.volume_db, target_db, step)
			await get_tree().process_frame
		else:
			streamer.volume_db = target_db
			running_tweening = false
			music_tweened.emit()

func tween_sync_music_stream(streamer: AudioStreamPlayer, id: int = 0, target_db: float = 0, step: float = 1.0) -> void:
	var stream: AudioStream = streamer.stream
	var curVolume: float
	
	if (stream is AudioStreamSynchronized):
		curVolume = stream.get_sync_stream_volume(id)
	else:
		curVolume = stream.volume
	var goUpwards = curVolume < target_db
	
	while curVolume != target_db:
		curVolume = stream.get_sync_stream_volume(id)
		if (goUpwards && target_db > curVolume):
			stream.set_sync_stream_volume(id, curVolume + step)
		elif (target_db < curVolume):
			stream.set_sync_stream_volume(id, curVolume - step)
		else:
			stream.set_sync_stream_volume(id, target_db)
			music_tweened.emit()
		await get_tree().process_frame

func on_beat(idx := 0) -> void:
	music_beat.emit(idx)

func import_stream(file_path = "", loop_point := -1.0) -> AudioStream:
	var stream = null
	if (file_path is Array):
		stream = AudioStreamSynchronized.new()
		
		for i in file_path.size():
			var file := import_stream(file_path[i])
			stream.set_sync_stream(i, file)
	else:
		if file_path.begins_with("res://"):
			stream = load(file_path)
		elif file_path.ends_with(".mp3"):
			stream = AudioStreamMP3.load_from_file(file_path)
		elif file_path.ends_with(".ogg"):
			stream = AudioStreamOggVorbis.load_from_file(file_path)
		elif file_path.ends_with(".wav"):
			stream = AudioStreamWAV.load_from_file(file_path)
		
		if file_path.ends_with(".mp3"):
			stream.set_loop(loop_point >= 0)
			stream.set_loop_offset(loop_point)
		elif file_path.ends_with(".ogg"):
			stream.set_loop(loop_point >= 0)
			stream.set_loop_offset(loop_point)
	return stream
