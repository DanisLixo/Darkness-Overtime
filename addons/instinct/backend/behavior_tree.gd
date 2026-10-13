##Base BehaviorTree class
##
##The base node of all [b]Behavior Tree[/b] objects, for the root of a behavior tree, 
##see [BTRoot]
@abstract 
@icon("../icons/behavior_tree.svg")
class_name BehaviorTree
extends Node

##The return values for [method BehaviorTree._tick]
##[br]* [enum SUCCESS] means the operation has been done succesfully, allowing the tree to 
##continue to the next operation
##[br]* [enum FAILURE] means the operation failed, stopping all next operations until the next 
##frame is met
##[br]* [enum RUNNING] means the operation is running and makes the tree wait on it
enum TickReturn{
	SUCCESS,
	FAILURE,
	RUNNING
}

##The equivalent to [method Node._physics_process] for all [b]Behavior Tree[/b] instances
func _tick(delta : float) -> TickReturn:
	return TickReturn.SUCCESS
