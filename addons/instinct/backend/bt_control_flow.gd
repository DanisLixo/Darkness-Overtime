@abstract
@icon("../icons/bt_control_flow.svg")
##The nodes that will decide the next step for each leaf on a [BehaviorTree]
class_name BTControlFlow
extends BehaviorTree

##All the children inside the current [BTControlFlow]
var children : Array[BehaviorTree]

func _ready() -> void:
	for child in get_children():
		if child is BehaviorTree:
			children.append(child)
		else:
			printerr("%s found in %s" %[child.name, get_script().get_global_name()])
