class_name State
extends Node

@export var use_enter_as_ready := false

@onready var stateMachine: StateMachine = get_parent()
@onready var parent = stateMachine.owner

## Para os states nao rodarem todos ao mesmo tempo, utilizamos metodos diferentes dos originais para nao termos que desativar nodes nao utilizados.
func enter(_msg = {}) -> void:
	pass

func process(_delta: float) -> void:
	pass
	
func physics_process(_delta: float) -> void:
	pass

func exit(_msg = {}) -> void:
	pass
