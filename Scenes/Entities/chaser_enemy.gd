extends BasicEnemy
var current_state := "Chase"
func _physics_process(_delta: float) -> void:
	super(_delta)
	if player_arr.is_empty():
		if current_state != "Roam":
			current_state = "Roam"
			state_machine.change_state("Roam")
	else:
		if current_state != "Chase":
			current_state = "Chase"
			state_machine.change_state("Chase")
func _process(_delta: float) -> void:
	if health_component.current_health <= health_component.max_health / 2.:
		movement_component.sprint_speed = 5
