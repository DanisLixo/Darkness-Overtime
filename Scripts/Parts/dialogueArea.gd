class_name DialogueArea2D
extends Area2D

@export var activateInstant: bool
@export var onlyActivateOnce: bool
@export var overrideDialoguePosition: bool
@export var overridePosition: Vector2
@export var dialogue: Array[ResourceDE]

const dialogueSystemScene := preload("res://Scenes/Prefabs/UI/DialogueScene.tscn")
var dialogueTopPosition := Vector2(160, 48)
var dialogueBottomPosition := Vector2(160, 192)

var playerBodyIn := false
var alreadyActivated := false
var dialoguePosition: Vector2

var players: Array[Player]

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)

func _process(_delta: float) -> void:
	if (players.size() == 0):
		for i in get_tree().get_nodes_in_group("Players"):
			players.append(i)
		return
	if (!activateInstant && playerBodyIn):
		if (onlyActivateOnce && alreadyActivated):
			set_process(false)
			return
		if (Input.is_action_just_pressed("move_action")):
			activate_dialogue()
			playerBodyIn = false

func activate_dialogue() -> void:
	for i in players:
		i.stateMachine.change_state("Freeze")
		
	var dialogueNode := dialogueSystemScene.instantiate()
	if (overrideDialoguePosition):
		dialoguePosition = overridePosition
	else:
		var someoneOnBottom = false
		for i in players:
			if (i.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y):
				someoneOnBottom = true
		if (someoneOnBottom):
			dialoguePosition = dialogueTopPosition
		else:
			dialoguePosition = dialogueBottomPosition
	dialogueNode.activatorNode = self
	dialogueNode.global_position = dialoguePosition
	dialogueNode.dialogue = dialogue
	Global.gameHud.add_child(dialogueNode)
	dialogueNode.open()

func _on_body_entered(body: Node2D) -> void:
	if (onlyActivateOnce && alreadyActivated):
		return
	if (body.is_in_group("Players")):
		playerBodyIn = true
		if (activateInstant):
			activate_dialogue()

func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Players")):
		playerBodyIn = false
