@tool
class_name CameraLockArea2D extends AreaTrigger2D

@export_category("Entered Area")
@export var tweenTime := 0.5
@export var instant := false
@export var easeType := Tween.EaseType.EASE_IN_OUT
@export var zoom := Vector2(1, 1)

var cameraLocked := false

func player_entered(playerArea: Area2D) -> void:
	super(playerArea)
	
	if (playerIn):
		var player = playerArea.owner
		player.lock_camera(global_position, tweenTime, instant, easeType, zoom)
		cameraLocked = true

func player_exited(playerArea: Area2D) -> void:
	super(playerArea)
	
	if (!playerIn):
		var player = playerArea.owner
		player.unlock_camera()
		cameraLocked = false
