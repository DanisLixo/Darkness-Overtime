extends CharacterBody2D
@export var health_component : HealthComponent
@export var state_machine : StateMachine
@export var movement_component : MovementComponent
@export var protect_area : Area2D

var current_allies : Array[Node2D]

func _ready() -> void:
	health_component.killed.connect(die)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	current_allies = protect_area.get_overlapping_bodies().filter(func(body): return body != self)
	if state_machine.state.get_state_name() != "Protect":
		state_machine.change_state("Protect")

	if health_component.current_health <= health_component.max_health / 2. and state_machine.state.get_state_name() != "Chase":
		state_machine.change_state("Chase")
		state_machine.state.target = get_tree().get_first_node_in_group("Players")
		movement_component.sprint_speed = 5
		
	if !current_allies.is_empty() and state_machine.state.get_state_name() == "Protect":
		state_machine.state.target = current_allies[0]
	
	
func die():
	queue_free()
