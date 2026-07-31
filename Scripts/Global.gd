extends Node

@onready var mouse := $Mouse/MouseSprite

var current_room: Room

var players: Array[Player] = [null]

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	handle_mouse()
	
func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()
