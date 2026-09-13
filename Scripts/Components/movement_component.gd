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

func move_towards(position:Vector2, is_sprint:bool = false) -> void:
	_get_values()
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	parent.velocity = position.direction_to(parent.global_position) * -cur_speed * 50 # TODO: PLEASE FIX THIS IT'S SO ASSS
	
func move_direction(direction:Vector2, is_sprint:bool) -> void:
	_get_values()
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	parent.velocity = direction * cur_speed

func move_tween(position:Vector2, is_sprint:bool = false) -> Tween:
	_get_values()
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	var tween = create_tween()
	tween.tween_property(parent, "position", position, cur_speed)
	return tween

func _get_values():
	if effects_handler:
		var new_values : Dictionary[StringName, Variant] = effects_handler.override_action(StatusEffect.ActionType.MOVE)
		speed = new_values.get(&"MovementComponent.speed")
		sprint_speed = new_values.get(&"MovementComponent.sprint_speed")

func _register_values() -> Dictionary[StringName, Variant]:
	var default_values : Dictionary[StringName, Variant] = {
		&"speed": speed,
		&"sprint_speed": sprint_speed
	}
	return default_values
	
