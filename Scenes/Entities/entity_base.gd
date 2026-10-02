class_name EntityBase
extends CharacterBody2D

@export var movement_component : MovementComponent
@export var state_machine : StateMachine
@export var effects_handler : StatusEffectsHandler
@export var health_component : HealthComponent
@export var interaction_area : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
