class_name NavigationComponent
extends NavigationAgent2D

@export var timer : Timer
var parent : CharacterBody2D
var direction : Vector2
var target : Node2D

func _ready() -> void:
	timer.start()
	parent = get_parent() as CharacterBody2D
	timer.timeout.connect(on_timer_timeout)

func _physics_process(_delta: float) -> void:
	if parent:
		direction = parent.global_position.direction_to(get_next_path_position())

func on_timer_timeout():
	if target:
		target_position = target.global_position
