class_name StateMachine
extends Node

@export var initialState: State
@onready var state := initialState

## Usado para administrar os states que modificam o objeto principal.
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

## Muda o state atual (incrivel), MSGs sao para caso algum state precisa de algo para funcionar, assim pode ser listada num dicionario
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
