class_name Camera2DHandler extends Node2D

@onready var player: Player = get_parent()
var camera: Camera2D
var cameraLocked = -1

var cameraFixTween: Tween
var cameraZoomTween: Tween

func _ready() -> void:
	await player.ready
	camera = player.camera

func _process(delta: float) -> void:
	if (cameraLocked is Vector2):
		camera.global_position = cameraLocked

func lock_current_camera(toPosition := Vector2.ZERO, tweenTime := 5.0, instant := false, easeTween := Tween.EaseType.EASE_OUT, zoom := Vector2(1, 1)) -> void:
	if (!camera.enabled):
		get_viewport().get_camera_2d().enabled = false
		camera.enabled = true
	
	if (!instant):
		if (cameraFixTween): cameraFixTween.kill()
		cameraFixTween = create_tween()
		cameraFixTween.set_ease(easeTween)
		cameraFixTween.tween_property(camera, "global_position", toPosition, tweenTime)
		
		if (cameraZoomTween): cameraZoomTween.kill()
		cameraZoomTween = create_tween()
		cameraZoomTween.set_ease(easeTween)
		cameraZoomTween.tween_property(camera, "zoom", zoom, tweenTime)
	else:
		if (cameraFixTween): cameraFixTween.kill()
		cameraFixTween = create_tween()
		cameraFixTween.set_ease(easeTween)
		cameraFixTween.tween_property(camera, "global_position", toPosition, 0.0)
		
		if (cameraZoomTween): cameraZoomTween.kill()
		cameraZoomTween = create_tween()
		cameraZoomTween.set_ease(easeTween)
		cameraZoomTween.tween_property(camera, "zoom", zoom, 0.0)
	
	await cameraFixTween.finished
	cameraLocked = toPosition

func unlock_camera() -> void:
	if (cameraFixTween): cameraFixTween.kill()
	
	if (cameraZoomTween): cameraZoomTween.kill()
	cameraZoomTween = create_tween()
	cameraZoomTween.tween_property(camera, "zoom", Vector2(1, 1), 0.5)
	
	camera.global_position = player.global_position
	cameraLocked = -1
