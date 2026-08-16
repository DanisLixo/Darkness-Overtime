extends State

@onready var sprite = parent.sprite as AnimatedSprite2D
@onready var movement_component = parent.movement_component as MovementComponent

var target : Vector2

func process(_delta: float) -> void:
	target = parent.player_arr[0].global_position
	movement_component.move_towards(target, true)

func enter(_msg = {}) -> void:
	sprite.play("walk_front")
	
func exit(_msg = {}) -> void:
	sprite.stop()
