class_name Player
extends CharacterBody2D

#region Physics Variables
var WALK_MAX_SPEED := 200.0
var WALK_ACCEL := 20.0

var RUN_MAX_SPEED := 480.0
var RUN_ACCEL := 35.0

var DECEL := 90.0
#endregion

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var stateMachine: StateMachine = $States

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

func get_input() -> void:
	inputDirection = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	keyPress[INPUT.ACTION] = Input.is_action_just_pressed("move_action")
	keyPress[INPUT.RUN] = Input.is_action_just_pressed("move_run")
	
	keyHold[INPUT.ACTION] = Input.is_action_pressed("move_action")
	keyHold[INPUT.RUN] = Input.is_action_pressed("move_run")

func _process(delta: float) -> void:
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

## Bem simples, neh?
func handle_animations() -> void:
	handle_animation_direction()
	
	sprite.animation = sprName + "_" + directionSprName
	sprite.play()

var sprName: String = "idle"
var directionSprName: String = "front"
func handle_animation_direction() -> void:
	if (direction.y == 1):
		directionSprName = "front"
	if (direction.y == -1):
		directionSprName = "back"
	elif (direction.x != 0):
		directionSprName = "side"
		if (direction.x != 0):
			sprite.scale.x = -direction.x
		else:
			sprite.scale.x = 1
