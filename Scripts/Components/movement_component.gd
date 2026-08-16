extends Node
class_name MovementComponent

@onready var parent : CharacterBody2D = get_parent()
@export var speed : float = 2.5
@export var sprint_speed : float = 0.

func move_towards(position:Vector2, is_sprint:bool = false) -> void:
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	parent.global_position = parent.global_position.move_toward(position, cur_speed)
	
func move_direction(direction:Vector2, is_sprint:bool) -> void:
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	parent.velocity = direction * cur_speed

func move_tween(position:Vector2, is_sprint:bool = false) -> Tween:
	var cur_speed = sprint_speed if is_sprint and sprint_speed != 0 else speed
	var tween = create_tween()
	tween.tween_property(parent, "position", position, cur_speed)
	return tween
