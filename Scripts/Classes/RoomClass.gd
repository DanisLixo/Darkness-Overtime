@tool
extends Node
class_name RoomClass

@export var isPlayableRoom := true
@export var areaName := "Area withou name"
@export var areaGroup := ""
@export var music: AudioStream

func _enter_tree() -> void:
	Global.currentRoom = self

func set_music(newMusic: AudioStream = null) -> void:
	music = newMusic
	AudioManager.handle_music(0)

func set_current_sync(id := 0) -> void:
	AudioManager.set_current_used_sync(id, 2.5, 5)
