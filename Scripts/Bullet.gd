extends CharacterBody2D

var SPEED := 320.0
@export var hitbox_component : HitboxComponent

func _ready() -> void:
	hitbox_component.area_entered.connect(hit_something.bind())

func set_direction(direction: Vector2) -> void:
	velocity = direction * SPEED

func _physics_process(_delta: float) -> void:
	move_and_slide()

func hit_something(_body: Area2D) -> void:
	explode()
	
func explode() -> void:
	queue_free()
