class_name MovementComponent
extends Node

@onready var parent : CharacterBody2D = get_parent()
@onready var real_z_index : int = parent.z_index

@export var interaction_area : Area2D

@export var movement_stats = MovementStats.new()

var effects_handler : StatusEffectsHandler = null

var override_values : Dictionary[StringName, Variant]
var input_direction : Vector2 = Vector2.ZERO
var direction : Vector2i = Vector2i.ZERO

var can_run : bool = true

var can_jump : bool = true
var jump_cooldown : bool = 0

var is_skidding : bool = false
var is_running : bool = false

var global_position_z : float = 0.0
var velocity_z : float = 0.0

func _ready() -> void:
	add_to_group(&"StatusAffectable")

func _register_values() -> Dictionary[StringName, Variant]:
	var default_values : Dictionary[StringName, Variant]

	return default_values
	
func move_direction(running: bool, new_input_direction: Vector2) -> void:
	if effects_handler:
		input_direction = new_input_direction
		override_values = effects_handler.override_action(StatusEffect.ActionType.MOVE)
		ground_acceleration(running)
		deceleration()

func move_tween(position:Vector2, is_sprint:bool = false):
	if effects_handler:
		override_values = movement_stats.get_overrides(StatusEffect.ActionType.MOVE)
	#var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	#var tween = create_tween()
	#tween.tween_property(parent, "position", position, cur_speed)
	#return tween
	
func ground_acceleration(running: bool) -> void:
	var target_accel = override_values.get(&"MovementStats.walk_acceleration")
	var target_speed = override_values.get(&"MovementStats.walk_max_speed")
	if (can_run and running):
		target_accel = override_values.get(&"MovementStats.run_acceleration")
		target_speed = override_values.get(&"MovementStats.run_max_speed")

	if (input_direction.x != 0.0):
		parent.velocity.x = move_toward(parent.velocity.x, target_speed * input_direction.x, target_accel)
	if (input_direction.y != 0.0):
		parent.velocity.y = move_toward(parent.velocity.y, target_speed * input_direction.y, target_accel)

func deceleration() -> void:
	var target_decel : float = override_values.get(&"MovementStats.walk_deceleration") if !is_skidding else override_values.get(&"MovementComponent.run_deceleration")
	if (input_direction.x == 0.0):
		parent.velocity.x = move_toward(parent.velocity.x, 0.0, target_decel)
	if (input_direction.y == 0.0):
		parent.velocity.y = move_toward(parent.velocity.y, 0.0, target_decel)
	if (parent.velocity == Vector2.ZERO):
		is_skidding = false
		
func jump() -> void:
	override_values = effects_handler.override_action(StatusEffect.ActionType.JUMP)
	velocity_z = -override_values.get(&"MovementStats.jump_height")

func _physics_process(_delta: float) -> void:
	if not is_actually_on_floor() and effects_handler:
		var gravity: float = override_values.get(&"MovementStats.jump_gravity")
		velocity_z += gravity
		deceleration()
	else:
		velocity_z = 0
	
func z_move(delta: float) -> void:
	if (global_position_z + (velocity_z * delta) >= 0.0):
		velocity_z = 0.0
		global_position_z = 0.0
	
	global_position_z += velocity_z * delta
	
	parent.set_collision_mask_value(1, is_actually_on_floor())
	parent.set_collision_mask_value(9, !is_actually_on_floor())
	if interaction_area:
		interaction_area.set_collision_layer_value(1, is_actually_on_floor())
		interaction_area.set_collision_layer_value(9, !is_actually_on_floor())
	
	parent.z_index = real_z_index + int(!is_actually_on_floor())
	
	if parent.sprite_joint:
		parent.sprite_joint.position.y = global_position_z

func is_actually_on_floor() -> bool:
	return global_position_z >= 0.0
