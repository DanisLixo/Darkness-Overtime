class_name BTFallback
extends BehaviorTree

func _tick(delta:float) -> TickReturn:
	for child in children:
		var ret_val : TickReturn = child._tick(delta)
		if ret_val == TickReturn.RUNNING:
			return TickReturn.RUNNING
		if ret_val == TickReturn.FAILURE:
			continue
	return TickReturn.SUCCESS
