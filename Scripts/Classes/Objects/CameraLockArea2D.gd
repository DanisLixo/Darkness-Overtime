class_name CameraLockArea2D extends Area2D

@export_category("Entered Area")
@export var tweenTime := 0.5
@export var instant := false
@export var easeType: Tween.EaseType
@export var zoom := Vector2(1, 1)

var cameraLocked := false

func _ready() -> void:
	area_entered.connect(player_entered)
	area_exited.connect(player_exited)
	
func player_entered(playerArea: Area2D) -> void:
	if (cameraLocked): return
	var player = playerArea.owner
	if (player is Player):
		player.lock_camera(global_position, tweenTime, instant, easeType, zoom)
		cameraLocked = true

func player_exited(playerArea: Area2D) -> void:
	var player = playerArea.owner
	if (player is Player):
		player.unlock_camera()
		cameraLocked = false
