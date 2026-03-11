extends Node

@export var cameraLimits: Vector2i = Vector2i(1000000, 1000000)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().get_camera_2d().limit_right = cameraLimits.x
	get_viewport().get_camera_2d().limit_bottom = cameraLimits.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
