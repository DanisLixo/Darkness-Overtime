##Base State class, used in tandem with the StateMachine class, each State should include their own
## code
class_name State
extends Node

@onready var state_machine: StateMachine = get_parent()
@onready var parent = state_machine.owner

#To prevent all states from running at the same time, we use different methods than the original ones 
#so we don't have to disable unused nodes.
func enter(_msg = {}) -> void:
	pass

func process(_delta: float) -> void:
	pass
	
func physics_process(_delta: float) -> void:
	pass

func exit(_msg = {}) -> void:
	pass

func get_state_name() -> String:
	return get_script().get_path().get_file().get_basename()
