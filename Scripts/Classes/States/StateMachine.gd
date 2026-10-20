##A state machine, used to manage the states that modify the main object, should be paired with any type of State classes
class_name StateMachine
extends Node

@export var initial_state: State
@onready var state : State = initial_state

func _ready() -> void:
	if (state == null):
		print("Given state doesn't exist for the following Scene: %s" % owner.scene_file_path.get_file())
		return

func _process(delta: float) -> void:
	if (state == null):
		return
	state.process(delta)

func _physics_process(delta: float) -> void:
	if (state == null):
		return
	state.physics_process(delta)

## Changes the current state, messages are for when a state needs something to function, 
##so it can be listed in a dictionary.
func change_state(state_name: String = "", exitMsg = {}, enterMsg = {}) -> void:
	if (state_name == ""):
		return
	
	var newState = get_node(state_name)
	
	if (newState != null):
		state.exit(exitMsg)
		state = newState
		state.enter(enterMsg)
	else:
		print("State with name: %s wasn't found within StateMachine's children for Scene: %s" % [state_name, owner.scene_file_path.get_file()])
