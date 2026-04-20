extends Node

const DEFAULT_SFX_LIBRARY := {
	"rain_ambience": "res://Assets/Audios/SFXs/Ambience/RainAmbienceTest.mp3",
	"rain_step": "res://Assets/Audios/SFXs/RainStepTest.wav"
}

@onready var musicPlayer: AudioStreamPlayer = $Music

var sfxLibrary := DEFAULT_SFX_LIBRARY.duplicate(true)
var activeSfxs := {}
var queuedSfxs := []

var overrideMusic: AudioStream

signal music_beat(idx)

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

func _process(delta: float) -> void:
	handle_music(delta)

func stop_all_music() -> void:
	AudioManager.musicPlayer.stop()
	if Global.currentRoom != null:
		Global.currentRoom.music = null

func kill_sfx(sfxName := "") -> void:
	if activeSfxs.has(sfxName):
		activeSfxs[sfxName].queue_free()
		activeSfxs.erase(sfxName)

func handle_music(delta: float) -> void:
	if is_instance_valid(Global.currentRoom):
		if (Global.currentRoom.music == null):
			tween_music_stream(-80, 0.5)
			await music_tweened
			musicPlayer.stop()
			return
		#musicPlayer.stream_paused = false
		if (!musicPlayer.playing):
			musicPlayer.stream = Global.currentRoom.music
			if (overrideMusic != null):
				musicPlayer.stream = overrideMusic
		if (musicPlayer.stream is AudioStreamSynchronized && !musicPlayer.playing):
			set_current_used_sync(0, 60)
		if (!musicPlayer.playing):
			musicPlayer.play()
			tween_music_stream(0, 5)
			await music_tweened

func set_current_used_sync(id := 0, stepDec := 0.0, stepInc := 0.0, muteOthers := true) -> void:
	if (musicPlayer.stream is not AudioStreamSynchronized):
		return
	
	var streamer: AudioStreamSynchronized = musicPlayer.stream
	
	for i in streamer.stream_count:
		if (i != id && muteOthers):
			tween_sync_music_stream(i, -60, stepDec)
		else:
			tween_sync_music_stream(i, 0, stepInc)

signal music_tweened

func tween_music_stream(target_db: float = 0, step: float = 1.0) -> void:
	var streamer = musicPlayer
	var curVolume: float = streamer.volume_db
	var goUpwards = curVolume < target_db
	
	while curVolume != target_db:
		curVolume = streamer.volume_db
		if (goUpwards && target_db > curVolume) || (!goUpwards && target_db < curVolume):
			streamer.volume_db = move_toward(streamer.volume_db, target_db, step)
		else:
			streamer.volume_db = target_db
			music_tweened.emit()
		await get_tree().process_frame

func tween_sync_music_stream(id: int = 0, target_db: float = 0, step: float = 1.0) -> void:
	var streamer: AudioStream = musicPlayer.stream
	var curVolume: float
	
	if (streamer is AudioStreamSynchronized):
		curVolume = streamer.get_sync_stream_volume(id)
	else:
		curVolume = streamer.volume
	var goUpwards = curVolume < target_db
	
	while curVolume != target_db:
		curVolume = streamer.get_sync_stream_volume(id)
		if (goUpwards && target_db > curVolume):
			streamer.set_sync_stream_volume(id, curVolume + step)
		elif (target_db < curVolume):
			streamer.set_sync_stream_volume(id, curVolume - step)
		else:
			streamer.set_sync_stream_volume(id, target_db)
			music_tweened.emit()
		await get_tree().process_frame

func on_beat(idx := 0) -> void:
	music_beat.emit(idx)

func import_stream(file_path := "", loop_point := -1.0) -> AudioStream:
	var stream = null
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
