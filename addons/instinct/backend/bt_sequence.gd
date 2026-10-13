@icon("../icons/bt_sequence.svg")
##[BTControlFlow] that only succeeds if all children succeed
class_name BTSequence
extends BTControlFlow

func _tick(delta:float) -> TickReturn:
	for child in children:
		var status : TickReturn = child._tick(delta)
		if status == TickReturn.FAILURE or status == TickReturn.RUNNING:
			return status
	return TickReturn.SUCCESS
