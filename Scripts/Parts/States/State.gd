class_name State
extends Node

@onready var stateMachine: StateMachine = get_parent()
@onready var parent = stateMachine.get_parent()

## Para os states nao rodarem todos ao mesmo tempo, utilizamos metodos diferentes dos originais para nao termos que desativar nodes nao utilizados.
func enter(_msg = {}) -> void:
	pass

func process(_delta: float) -> void:
	pass
	
func physics_process(_delta: float) -> void:
	pass

func exit(_msg = {}) -> void:
	pass
