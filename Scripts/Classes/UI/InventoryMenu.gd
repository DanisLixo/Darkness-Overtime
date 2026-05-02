extends Control

@onready var currentContainer: Control = $InvSection
@export var containers: Array[Control]
@export var sectionImages: Array[TextureRect]
var selectingCategory := true
var categoryIndex := 0

var active := true
var canMove := true

signal opened
signal closed

func _ready() -> void:
	close()
	
	if (containers.size() != 0):
		currentContainer = containers[0]

## Para navegacao, ainda nao muito bem implementado.
func _process(_delta: float) -> void:
	selectingCategory = currentContainer.selectedIndex.y == -1
	
	for i in containers.size():
		sectionImages[i].selected = categoryIndex == i and active
		containers[i].active = categoryIndex == i and active
	
	if (active && canMove && selectingCategory):
		handle_inputs()

func handle_inputs() -> void:
	var direction := int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	
	if (Input.is_action_just_pressed("toggle_inventory")):
		close()
	
	categoryIndex += direction
	categoryIndex = wrapi(categoryIndex, 0, containers.size())
	
	currentContainer = containers[categoryIndex]

func open() -> void:
	show()
	Global.currentState = Global.PlayState.INMENUS
	
	await get_tree().process_frame
	Global.paused = true
	get_tree().paused = true
	
	active = true
	opened.emit()
	
func close() -> void:
	Global.currentState = Global.PlayState.PLAYING
	
	Global.paused = false
	get_tree().paused = false
	
	print("Botao apertado")
	for i: Player in get_tree().get_nodes_in_group("Players"):
		if (!i.is_node_ready()):
			await i.ready
		i.stateMachine.change_state("Normal")
	active = false
	hide()
	closed.emit()
