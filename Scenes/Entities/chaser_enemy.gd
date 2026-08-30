extends CharacterBody2D
@export var health_component : HealthComponent
@export var state_machine : StateMachine
@export var movement_component : MovementComponent
@export var hitbox_component : HitboxComponent

func _ready() -> void:
	health_component.killed.connect(die)
	hitbox_component.area_entered.connect(hit_player.bind())
func _physics_process(_delta: float) -> void:
	move_and_slide()
	if get_tree().get_node_count_in_group("Players") != 0:
		state_machine.state.target = get_tree().get_first_node_in_group("Players")
func _process(_delta: float) -> void:
	if health_component.current_health <= health_component.max_health / 2.:
		movement_component.sprint_speed = 5
func die():
	queue_free()
	
func hit_player(player:Node2D):
	
	pass
