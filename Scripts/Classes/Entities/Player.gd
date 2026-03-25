class_name Player
extends CharacterBody2D

#region Physics Variables
var WALK_MAX_SPEED := 200.0
var WALK_ACCEL := 20.0

var RUN_MAX_SPEED := 480.0
var RUN_ACCEL := 35.0

var DECEL := 90.0
#endregion

@onready var sprite: AnimatedSprite2D = $SpriteJoint/Sprite
@onready var stateMachine: StateMachine = $States
@onready var hintText := $HintText

var direction: Vector2i

enum INPUT {
	ACTION,
	RUN
}

var inputDirection: Vector2
var keyPress: Array = [0, 0]
var keyHold: Array = [0, 0]

var character := "Placeholder"
var can_run := true

var debugging = false

@onready var camera: Camera2D = $Camera
@onready var cameraHandler: Camera2DHandler = $CameraHandler

func _process(_delta: float) -> void:
	if (hintText != null):
		var newText := "move_action"
		
		hintText.text = newText.replace(newText, "Z")
	
	if (Input.is_action_just_pressed("debug_key")):
		if (debugging):
			debugging = false
			stateMachine.change_state("Normal")
		else:
			debugging = true
			sprName = "idle"
			stateMachine.change_state("NoClip")
	
	get_input()
	handle_animations()

func set_spawnpoint(spawnpoint: PlayerSpawnpoint) -> void:
	global_position = spawnpoint.global_position

func get_input() -> void:
	inputDirection = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	keyPress[INPUT.ACTION] = Input.is_action_just_pressed("move_action")
	keyPress[INPUT.RUN] = Input.is_action_just_pressed("move_run")
	
	keyHold[INPUT.ACTION] = Input.is_action_pressed("move_action")
	keyHold[INPUT.RUN] = Input.is_action_pressed("move_run")

func lock_camera(toPosition := Vector2.ZERO, tweenTime := 5.0, instant := false, easeType := Tween.EaseType.EASE_OUT, zoom := Vector2(1, 1)) -> void:
	cameraHandler.lock_current_camera(toPosition, tweenTime, instant, easeType, zoom)

func unlock_camera() -> void:
	cameraHandler.unlock_camera()

## Bem simples, neh?
func handle_animations() -> void:
	handle_animation_direction()
	if (stateMachine.state.name == "Freeze"):
		sprName = "idle"
	
	var fah = sprite.animation
	if (fah.contains(sprName)):
		sprite.animation = sprName + "_" + directionSprName
	else:
		sprite.play(sprName + "_" + directionSprName)

var sprName: String = "idle"
var directionSprName: String = "front"
func handle_animation_direction() -> void:
	if (direction.y != 0):
		sprite.offset.x = 0.0
		
		if (direction.y == 1):
			directionSprName = "front"
		if (direction.y == -1):
			directionSprName = "back"
		sprite.scale.x = direction.y
	elif (direction.x != 0):
		sprite.scale.x = 1
		sprite.offset.x = 31.0 * (-direction.x)
		if (direction.x == -1):
			directionSprName = "left"
		else:
			directionSprName = "right"
