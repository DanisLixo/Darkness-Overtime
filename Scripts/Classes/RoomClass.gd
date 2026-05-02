@tool
extends Node
class_name RoomClass

@export var isPlayableRoom := true
@export var areaName := "Area withou name"
@export var areaGroup := ""
@export var music: AudioStream
@export var cameraLimits: Vector2i = Vector2i(1000000, 1000000)

@onready var camera := get_viewport().get_camera_2d()

func _enter_tree() -> void:
	if (isPlayableRoom):
		Global.currentState = Global.PlayState.PLAYING
		Global.currentMode = Global.GameMode.FREEROAM
	else:
		Global.currentState = Global.PlayState.INMENUS
		Global.currentMode = Global.GameMode.SPECIAL
	Global.currentRoom = self

func _ready() -> void:
	if (camera != null):
		camera.limit_right = cameraLimits.x
		camera.limit_bottom = cameraLimits.y

func set_music(newMusic: AudioStream = null) -> void:
	music = newMusic
	AudioManager.handle_music(0)

func set_current_sync(id := 0) -> void:
	AudioManager.set_current_used_sync(id, 2.5, 5)
