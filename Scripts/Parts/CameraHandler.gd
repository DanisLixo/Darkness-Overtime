class_name Camera2DHandler extends Node2D

@onready var player: Player = get_parent()
var camera: Camera2D
var cameraLocked = -1

var cameraFixTween: Tween
var cameraZoomTween: Tween

var savedSmoothing := 0.0

signal zoom_tweened
signal position_tweened

func _ready() -> void:
	await player.ready
	camera = player.camera
	camera.make_current()
	camera.reset_smoothing()

func _process(_delta: float) -> void:
	if (cameraLocked is Vector2):
		camera.global_position = cameraLocked

func apply_zoom(zoom := Vector2.ONE, tweenTime := 5.0, easeTween := Tween.EaseType.EASE_OUT) -> void:
	if (cameraZoomTween): cameraZoomTween.kill()
	cameraZoomTween = create_tween()
	cameraZoomTween.set_ease(easeTween)
	cameraZoomTween.tween_property(camera, "zoom", zoom, tweenTime)
	
	await cameraZoomTween.finished
	zoom_tweened.emit()

func fix_to_position(toPosition := Vector2.ZERO, tweenTime := 5.0, easeTween := Tween.EaseType.EASE_OUT) -> void:
	if (cameraFixTween): cameraFixTween.kill()
	cameraFixTween = create_tween()
	cameraFixTween.set_ease(easeTween)
	cameraFixTween.tween_property(camera, "global_position", toPosition, tweenTime)
	
	await cameraFixTween.finished
	position_tweened.emit()

func lock_current_camera(newCamera: Camera2D, toPosition := Vector2.ZERO, tweenTime := 5.0, easeTween := Tween.EaseType.EASE_OUT, zoom := Vector2(1, 1)) -> void:
	camera = newCamera
	savedSmoothing = camera.position_smoothing_speed
	
	if (!newCamera.enabled):
		get_viewport().get_camera_2d().enabled = false
		camera.enabled = true
	
	apply_zoom(zoom, tweenTime, easeTween)
	fix_to_position(toPosition, tweenTime, easeTween)
	
	await position_tweened
	cameraLocked = toPosition

func unlock_camera() -> void:
	if (cameraFixTween): cameraFixTween.kill()
	
	apply_zoom(Vector2.ONE, 0.5)
	
	camera.position_smoothing_speed = savedSmoothing
	camera.global_position = player.global_position
	cameraLocked = -1
