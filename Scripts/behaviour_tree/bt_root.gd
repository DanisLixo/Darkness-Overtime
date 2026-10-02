class_name BTRoot
extends BehaviorTree

@export_custom(PROPERTY_HINT_RANGE, "1, 20, suffix:per second") var tick_speed : int = 1:
	set(new_val):
		tick_speed = new_val
		updates_per_second = 1. / tick_speed
var updates_per_second : float
var time : float = 0

func _physics_process(delta: float) -> void:
	time += delta
	if time >= updates_per_second:
		if !children.is_empty():
			var ret_val = children[0]._tick(delta)
			print_debug(TickReturn.keys()[ret_val])
		time = 0
