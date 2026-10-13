@abstract
@icon("../icons/bt_wrapper.svg")
class_name BTWrapper
extends BehaviorTree

var child : BehaviorTree
func _ready() -> void:
	child = get_children()[0]
	
func _tick(delta : float) -> TickReturn:
	return TickReturn.SUCCESS
