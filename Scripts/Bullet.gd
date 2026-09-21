extends CharacterBody2D

var SPEED := 320.0

func set_mouse_direction(mouse_direction: Vector2) -> void:
	velocity = mouse_direction * SPEED

func _physics_process(_delta: float) -> void:
	move_and_slide()

func hit_something(_body: Node2D) -> void:
	explode()
	
func explode() -> void:
	queue_free()
