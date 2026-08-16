extends CharacterBody2D

var SPEED := 320.0

func set_direction(direction: Vector2) -> void:
	velocity = direction * SPEED

func _physics_process(_delta: float) -> void:
	move_and_slide()

func hit_something(_body: Area2D) -> void:
	explode()
	
func explode() -> void:
	queue_free()
