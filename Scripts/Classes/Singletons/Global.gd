extends Node

## Sem funcao por agora, somente eh um autoload
@onready var gameHud := $GameHud
@onready var mouse := $Misc/AnimatedSprite2D

var itemsLoad := ["PlaceholderBurger", "PlaceholderWhip", "PlaceholderKey"]

var ambience := "rain"
var inCutscene := false
var currentRoom: RoomClass

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	handle_mouse()
	
func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()

func transition_to_scene(scene_path: String = "") -> void:
	if (load(scene_path) == null):
		printerr("Cena nao encontrada.")
		return
	
	$Misc/ColorRect.show()
	$Misc/AnimationPlayer.play("fade_in")
	await $Misc/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene_path)
	$Misc/AnimationPlayer.play_backwards("fade_in")

func add_dialogue(dialogue) -> void:
	inCutscene = true
	$CanvasLayer.add_child(dialogue)
	dialogue.open()
