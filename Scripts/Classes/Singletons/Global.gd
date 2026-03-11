extends Node

## Sem funcao por agora, somente eh um autoload
@onready var gameHud := $GameHud
@onready var mouse := $GameHud/AnimatedSprite2D

var itemsLoad := ["PlaceholderBurger", "PlaceholderWhip", "PlaceholderKey"]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	handle_mouse()
	
func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()

func transition_to_scene(scene_path: String = "") -> void:
	get_tree().change_scene_to_file(scene_path)
