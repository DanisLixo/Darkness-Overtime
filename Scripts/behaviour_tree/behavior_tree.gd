##Base BehaviorTree class, shouldn't be used as it's only purpose is 
##to be inherited from
@abstract class_name BehaviorTree
extends Node

enum TickReturn{
	SUCCESS,
	FAILURE,
	RUNNING
}

var children : Array[BehaviorTree]

func _ready() -> void:
	for child in get_children():
		if child is BehaviorTree:
			children.append(child)
		else:
			printerr("%s found in %s" %[child.name, get_script().get_global_name()])

func _tick(delta : float) -> TickReturn:
	return TickReturn.SUCCESS
