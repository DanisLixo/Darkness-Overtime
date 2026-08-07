@tool
class_name DialogueArea2D extends AreaTrigger2D

@export var activateInstant: bool
@export var onlyActivateOnce: bool
@export var dialogue: DialogueArray

# const dialogueSystemScene := preload("res://Scenes/Prefabs/UI/DialogueScene.tscn")
var alreadyActivated := false

var players: Array[Player]

func _ready() -> void:
	super()
	
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)

func _process(_delta: float) -> void:
	if (players.size() == 0):
		for i in get_tree().get_nodes_in_group("Players"):
			players.append(i)
		return
	if (!activateInstant && playerIn):
		if (onlyActivateOnce && alreadyActivated):
			set_process(false)
			return
		if (Input.is_action_just_pressed("move_action")):
			activate_dialogue()
			playerIn = false

func activate_dialogue() -> void:
	for i in players:
		i.stateMachine.change_state("Freeze")
		
	#var dialogueNode := dialogueSystemScene.instantiate()
	#dialogueNode.activatorNode = self
	#dialogueNode.dialogue = dialogue
	#Global.add_dialogue(dialogueNode)

func _player_entered(playerArea: Area2D) -> void:
	super(playerArea)
	
	if (onlyActivateOnce && alreadyActivated):
		return
		
	if (playerIn):
		if (activateInstant):
			activate_dialogue()
