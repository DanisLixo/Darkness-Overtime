@icon("../icons/bt_fallback.svg")
##[BTControlFlow] that tries to run each child until one succeeds
class_name BTFallback
extends BTControlFlow

func _tick(delta:float) -> TickReturn:
	for i in children.size():
		var status : TickReturn = children[i]._tick(delta)
		
		if status == TickReturn.RUNNING:
			return TickReturn.RUNNING
		if status == TickReturn.FAILURE:
			if i == children.size() - 1:
				return TickReturn.FAILURE
			continue
		
	return TickReturn.SUCCESS
