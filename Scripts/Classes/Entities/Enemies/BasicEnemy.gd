class_name BasicEnemy extends CharacterBody2D

@export var health_component : HealthComponent
@export var state_machine : StateMachine
@export var movement_component : MovementComponent
@export var hitbox_component : HitboxComponent
@export var effects_handler : StatusEffectsHandlerNew

func _ready() -> void:
	health_component.killed.connect(die)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func die():
	queue_free()
