class_name MovementStats
extends ComponentStats

@export var jump_height : float
@export var jump_gravity : float = 0.
@export_group("Walking")
@export var walk_max_speed : float =  0.
@export var walk_acceleration : float =  0.
@export var walk_deceleration : float =  0.

@export_group("Running")
@export var run_max_speed : float = 0.
@export var run_acceleration : float =  0.
@export var run_deceleration: float = 0.
