class_name Player
extends Character

#region Physics Variables
var WALK_MAX_SPEED := 500.0
var WALK_ACCEL := 20.0

var RUN_MAX_SPEED := 720.0
var RUN_ACCEL := 35.0

var DECEL := 120.0
#endregion

@onready var hintText := $HintText

var can_run := true

var debugging = false

@onready var camera: Camera2D = $Camera
@onready var cameraHandler: Camera2DHandler = $CameraHandler

func _process(_delta: float) -> void:
	if (hintText != null):
		var newText := "move_action"
		
		hintText.text = newText.replace(newText, "Z")
	get_input()

func set_spawnpoint(spawnpoint: PlayerSpawnpoint) -> void:
	global_position = spawnpoint.global_position

func get_input() -> void:
	inputDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Isso normaliza a velocidade para serem sempre a base da velocidade maxima
	# Nao quero usar isso mas eu vou fingir que isso e um power up hehe
	# if inputDirection.length() > 0:
	# 	inputDirection = inputDirection.normalized()
	
	keyPress[INPUT.ACTION] = Input.is_action_just_pressed("move_action")
	keyPress[INPUT.RUN] = Input.is_action_just_pressed("move_run")
	
	keyHold[INPUT.ACTION] = Input.is_action_pressed("move_action")
	keyHold[INPUT.RUN] = Input.is_action_pressed("move_run")

func lock_camera(toPosition := Vector2.ZERO, tweenTime := 5.0, instant := false, easeType := Tween.EaseType.EASE_OUT, zoom := Vector2(1, 1)) -> void:
	cameraHandler.lock_current_camera(toPosition, tweenTime, instant, easeType, zoom)

func unlock_camera() -> void:
	cameraHandler.unlock_camera()
