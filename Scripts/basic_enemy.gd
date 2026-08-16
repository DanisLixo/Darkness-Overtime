##An abstract enemy class which should be inherited for all types of enemies
## and should also include every component it asks for
extends CharacterBody2D
class_name BasicEnemy
@export var state_machine : StateMachine
@export var chase_area : Area2D
@export var sprite : AnimatedSprite2D
@export var health_component : HealthComponent
@export var movement_component : MovementComponent
@export var collision_shape : CollisionShape2D
var player_arr : Array

func _physics_process(_delta: float) -> void:
	player_arr = get_overlapping_players()

func get_overlapping_players() -> Array[Player]:
	var play_arr : Array[Player]
	for area in chase_area.get_overlapping_areas():
		if area.get_parent() is Player:
			play_arr.append(area.get_parent())
	return play_arr
