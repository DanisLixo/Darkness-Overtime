extends Node
class_name MovementComponent

@onready var parent : CharacterBody2D = get_parent()
@export var speed : float = 2.5
@export var sprint_speed : float = 0.

@export_group("Walking")
@export var WALK_MAX_SPEED : float =  300.0
@export var WALK_ACCELERATION : float =  35.0
@export var WALK_DECELERATION : float =  40.0

@export_group("Running")
@export var RUN_MAX_SPEED : float = 500.0
@export var RUN_ACCELERATION : float =  5.0
@export var RUN_DECELERATION: float = 75.0

var effects_handler : StatusEffectsHandler = null

var override_values : Dictionary[StringName, Variant]
var direction : Vector2 = Vector2i.ZERO

var can_run : bool = true

var can_jump : bool = true
var jump_cooldown : bool = 0

var is_skidding : bool = false
var is_running : bool = false

func _register_values() -> Dictionary[StringName, Variant]:
	var default_values : Dictionary[StringName, Variant] = {
		&"speed": speed,
		&"sprint_speed": sprint_speed,
		
		&"walk_accel": WALK_ACCELERATION,
		&"walk_decel": WALK_DECELERATION,
		&"walk_max_speed": WALK_MAX_SPEED,
		
		&"run_accel": RUN_ACCELERATION,
		&"run_decel": RUN_DECELERATION,
		&"run_max_speed": RUN_MAX_SPEED,
		
		&"is_skidding": is_skidding,
		&"is_running": is_running,
		&"can_run": can_run,
		
		&"can_jump": can_jump,
		&"jump_cooldown": jump_cooldown,
		
	}
	return default_values
	
func move_towards(position:Vector2, is_sprint:bool = false) -> void:
	_get_values(StatusEffect.ActionType.MOVE)
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	parent.velocity = position.direction_to(parent.global_position) * -cur_speed * 50 # TODO: PLEASE FIX THIS IT'S SO ASSS
	
func move_direction(running: bool, input_direction: Vector2) -> void:
	if !effects_handler:
		await get_tree().process_frame
	_get_values(StatusEffect.ActionType.MOVE)
	ground_acceleration(running, input_direction)
	deceleration(input_direction)

func move_tween(position:Vector2, is_sprint:bool = false) -> Tween:
	_get_values(StatusEffect.ActionType.MOVE)
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	var tween = create_tween()
	tween.tween_property(parent, "position", position, cur_speed)
	return tween
	
func ground_acceleration(running: bool, input_direction: Vector2) -> void:
	if (is_skidding):
		return
	
	var target_accel = override_values.get(&"MovementComponent.walk_accel")
	var target_speed = override_values.get(&"MovementComponent.walk_max_speed")
	
	if (can_run and running):
		target_accel = override_values.get(&"MovementComponent.run_accel")
		target_speed = override_values.get(&"MovementComponent.run_max_speed")
	
	if (input_direction.x != 0.0):
		parent.velocity.x = move_toward(parent.velocity.x, target_speed * input_direction.x, target_accel)
	if (input_direction.y != 0.0):
		parent.velocity.y = move_toward(parent.velocity.y, target_speed * input_direction.y, target_accel)

func deceleration(input_direction : Vector2) -> void:
	var target_decel : float = override_values.get(&"MovementComponent.walk_decel") if !is_skidding else override_values.get(&"MovementComponent.run_decel")
	if (input_direction.x == 0.0):
		parent.velocity.x = move_toward(parent.velocity.x, 0.0, target_decel)
	if (input_direction.y == 0.0):
		parent.velocity.y = move_toward(parent.velocity.y, 0.0, target_decel)
	if (parent.velocity == Vector2.ZERO):
		is_skidding = false

func _get_values(type : StatusEffect.ActionType):
	if effects_handler:
		override_values.assign(effects_handler.override_action(type))
