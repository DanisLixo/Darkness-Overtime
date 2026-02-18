class_name StateMachine
extends Node

@export var initialState: State
@onready var state = initialState

## Usado para administrar os states que modificam o objeto principal.
func _ready() -> void:
	state.enter()

func _process(delta: float) -> void:
	state.process(delta)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

## Muda o state atual (incrivel), MSGs sao para caso algum state precisa de algo para funcionar, assim pode ser listada num dicionario
func change_state(stateName: String = "", exitMsg = {}, enterMsg = {}) -> void:
	if (stateName == ""):
		return
	
	var newState = get_node(stateName)
	
	if (newState != null):
		state.exit(exitMsg)
		state = newState
		state.enter(enterMsg)
	else:
		print("State com o nome: " + stateName + "nao encontrado entre os filhos do StateMachine!")
