class_name Player
extends Character

#region Physics Variables
var RPG_PHYSICS := {
	"WALK_ACCEL": 20.0,
	"WALK_MAX_SPEED": 500.0,
	
	"RUN_ACCEL": 35.0,
	"RUN_MAX_SPEED": 720.0,
	
	"DECEL": 120.0,
}

var COMBAT_PHYSICS := {
	"WALK_ACCEL": 20.0,
	"WALK_MAX_SPEED": 500.0,
	
	"RUN_ACCEL": 35.0,
	"RUN_MAX_SPEED": 720.0,
	
	"DECEL": 120.0,
}

var physics := RPG_PHYSICS
#endregion

@onready var hintText := $HintText

var can_run := true

var debugging = false

@onready var camera: Camera2D = $Camera
@onready var cameraHandler: Camera2DHandler = $CameraHandler

static var money := 0
static var inventory := [ItemHandler.ID.PLACEHOLDER_BURGER]
var pathId = 0;

func _ready() -> void:
	Global.mode_changed.connect(handle_states)

func _process(_delta: float) -> void:
	
	path_array.append( {"position": position, "dir": direction} )
	
	pathId += 1;
	if pathId > 6:
		pathId = 0;
		
	if (hintText != null):
		var newText := "move_action"
		
		hintText.text = newText.replace(newText, "Z")
		
func _physics_process(delta: float) -> void:
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

func handle_states(newMode := 0) -> void:
	match newMode:
		Global.GameMode.FREEROAM:
			stateMachine.change_state("RPG")
		Global.GameMode.BATTLE:
			stateMachine.change_state("Combat")
