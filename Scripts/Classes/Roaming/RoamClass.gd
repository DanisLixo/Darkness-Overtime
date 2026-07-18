@tool
class_name RoamRoomClass extends RoomClass

@export var cameraLimits: Vector2i = Vector2i(1000000, 1000000)
@onready var camera := get_viewport().get_camera_2d()

func _enter_tree() -> void:
	Global.currentRoom.scenePath = scene_file_path
	Global.currentRoom.areaName = areaName
	Global.currentRoom.areaGroup = areaGroup
	if (music != null):
		Global.currentRoom.music = music.resource_path
	
	if (!Engine.is_editor_hint() && has_node("DebugCamera")):
		get_node("DebugCamera").free()
	Global.currentState = Global.PlayState.PLAYING
	Global.currentMode = Global.GameMode.FREEROAM

func _ready() -> void:
	if (camera != null):
		camera.limit_right = cameraLimits.x
		camera.limit_bottom = cameraLimits.y
	
func _process(delta: float) -> void:
	if (Engine.is_editor_hint()):
		camera_limit_debug()

func camera_limit_debug() -> void:
	var debugCamera := get_node_or_null("DebugCamera")
	if (debugCamera != null):
		debugCamera.limit_right = cameraLimits.x
		debugCamera.limit_bottom = cameraLimits.y
