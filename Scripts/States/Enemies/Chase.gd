extends State

@export var sprite : AnimatedSprite2D
@export var movement_component : MovementComponent
@export var navigation_component : NavigationComponent
var target : Node2D

func process(_delta: float) -> void:
	if target:
		navigation_component.target = target
		movement_component.move_direction(false, navigation_component.direction)
		

func enter(_msg = {}) -> void:
	sprite.play("walk_front")
	
func exit(_msg = {}) -> void:
	sprite.stop()
