extends BasicEnemy

@export var protect_area : Area2D

var current_allies : Array[Node2D]

func _physics_process(delta: float) -> void:
	super(delta)
	
	current_allies = protect_area.get_overlapping_bodies().filter(func(body): return body != self)
	if state_machine.state.get_state_name() != "Protect":
		state_machine.change_state("Protect")
	if health_component.current_health <= health_component.max_health / 2. and state_machine.state.get_state_name() != "Chase":
		state_machine.change_state("Chase")
		state_machine.state.target = get_tree().get_first_node_in_group("Players")
	if state_machine.state.get_state_name() == "Protect":
		if !current_allies.is_empty():
			state_machine.state.target = current_allies[0]
		else:
			state_machine.state.target = null
