extends Node2D
class_name RoomClass

@export var music: AudioStream
@export var cameraLimits: Vector2i = Vector2i(1000000, 1000000)
@export var areaGroup := ""

func _enter_tree() -> void:
	Global.currentRoom = self

func _ready() -> void:
	get_viewport().get_camera_2d().limit_right = cameraLimits.x
	get_viewport().get_camera_2d().limit_bottom = cameraLimits.y

func set_music(newMusic: AudioStream = null) -> void:
	AudioManager.stop_all_music()
	music = newMusic
	AudioManager.handle_music(0)

func set_current_sync(id := 0) -> void:
	AudioManager.set_current_used_sync(id, 2.5, 5)
