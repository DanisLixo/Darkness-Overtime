extends Node

const dialogueSystemScene := preload("res://Scenes/Prefabs/UI/DialogueScene.tscn")

var playerBodyIn := false
var alreadyActivated := false
var dialoguePosition: Vector2

var players: Array[Player]
@onready var npc: GenericNPC = get_parent()
@onready var hintText := $"../HintText"

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)

func _process(_delta: float) -> void:
	if (players.size() == 0):
		for i in get_tree().get_nodes_in_group("Players"):
			players.append(i)
		return
	if (playerBodyIn):
		if (npc.onlyActivateOnce && alreadyActivated):
			set_process(false)
			return
		if (Input.is_action_just_pressed("move_action")):
			activate_dialogue()
			playerBodyIn = false

func activate_dialogue() -> void:
	for i in players:
		i.stateMachine.change_state("Freeze")
		
	var dialogueNode := dialogueSystemScene.instantiate()
	dialogueNode.activatorNode = npc
	dialogueNode.global_position = dialoguePosition
	dialogueNode.dialogueArray = npc.dialogueArray[npc.interactionIdx]
	Global.add_dialogue(dialogueNode)
	dialogueNode.open()
	
	npc.interactionIdx += 1
	npc.interactionIdx = clampi(npc.interactionIdx, 0, npc.dialogueArray.size() - 1)

func _on_body_entered(body: Node2D) -> void:
	if (npc.onlyActivateOnce && alreadyActivated):
		return
	if (body.is_in_group("Players")):
		if (npc.dialogueArray != null && npc.dialogueArray.size() != 0):
			body.hintText.show()
		playerBodyIn = true

func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Players")):
		body.hintText.hide()
		playerBodyIn = false
