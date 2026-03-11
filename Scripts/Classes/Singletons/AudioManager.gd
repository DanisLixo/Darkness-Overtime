extends Node

const DEFAULT_SFX_LIBRARY := {}

@onready var musicPlayer := $Music
@onready var ambiencePlayer := $Ambience

var sfx_library := DEFAULT_SFX_LIBRARY.duplicate(true)
var active_sfxs := {}
var queued_sfxs := []

signal music_beat(idx)

func play_sfx(stream_name = "", position := Vector2.ZERO, pitch := 1.0, can_overlap := true) -> void:
	if sfx_library.has(stream_name): # SkyanUltra: Simple check that allows for custom optional sounds.
		if (not can_overlap and active_sfxs.has(stream_name)) or queued_sfxs.has(stream_name):
			return
		queued_sfxs.append(stream_name)
		if stream_name is String:
			if active_sfxs.has(stream_name):
				active_sfxs[stream_name].queue_free()
		var player = AudioStreamPlayer2D.new()
		player.global_position = position
		var stream = stream_name
		if stream_name is String:
			var stream_path = sfx_library[stream_name]
			if stream_path is Array:
				stream_path = stream_path.pick_random()
			stream = import_stream(stream_path)
		player.stream = stream
		player.autoplay = true
		player.pitch_scale = pitch
		player.max_distance = 99999
		player.bus = "SFX"
		add_child(player)
		active_sfxs[stream_name] = player
		queued_sfxs.erase(stream_name)
		await player.finished
		active_sfxs.erase(stream_name)
		player.queue_free()

func play_global_sfx(stream_name = "", pitch := 1.0) -> void:
	if get_viewport().get_camera_2d() == null:
		return
	play_sfx(stream_name, get_viewport().get_camera_2d().get_screen_center_position(), pitch)

func _process(_delta: float) -> void:
	handle_music()

func stop_all_music() -> void:
	AudioManager.music_player.stop()
	if Global.current_level != null:
		Global.current_level.music = null

func kill_sfx(sfx_name := "") -> void:
	if active_sfxs.has(sfx_name):
		active_sfxs[sfx_name].queue_free()
		active_sfxs.erase(sfx_name)

func load_sfx_map(json := {}) -> void:
	sfx_library = DEFAULT_SFX_LIBRARY.duplicate()
	for i in json:
		sfx_library[i] = json[i]

func handle_music() -> void:
	pass
	
func handle_ambience() -> void:
	pass

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
