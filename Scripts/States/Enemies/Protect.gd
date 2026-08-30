extends State

@export var sprite : AnimatedSprite2D
@export var movement_component : MovementComponent
var target : Node2D

func process(_delta: float) -> void:
	if target:
		movement_component.move_towards(target.global_position, true)
