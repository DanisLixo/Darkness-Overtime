extends Control

@export var containers: Array[Control]

var currentContainer: Control

var active := true

signal opened
signal closed

func _ready() -> void:
	if (containers.size() != 0):
		currentContainer = containers[0]

## Para navegacao, ainda nao muito bem implementado.
func _process(_delta: float) -> void:
	%Category.text = currentContainer.categoryName
	
	for i in [%LeftArrow, %RightArrow]:
		i.modulate.a = int(currentContainer.selectedIndex == Vector2i(-1, -1))
	if (Input.is_action_just_pressed("toggle_inventory")):
		if (!active):
			open()
		else:
			close()

func open() -> void:
	for i: Player in get_tree().get_nodes_in_group("Players"):
		i.stateMachine.change_state("Freeze")
	active = true
	show()
	opened.emit()
	
func close() -> void:
	for i: Player in get_tree().get_nodes_in_group("Players"):
		i.stateMachine.change_state("Normal")
	active = false
	hide()
	closed.emit()
