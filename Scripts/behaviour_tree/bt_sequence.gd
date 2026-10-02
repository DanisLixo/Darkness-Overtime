class_name BTSequence
extends BehaviorTree


func _tick(delta:float) -> TickReturn:
	for child in children:
		var ret_val : TickReturn = child._tick(delta)
		if ret_val == TickReturn.FAILURE or ret_val == TickReturn.RUNNING:
			return ret_val
	return TickReturn.SUCCESS
