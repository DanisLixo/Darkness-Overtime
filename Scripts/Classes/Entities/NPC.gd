class_name GenericNPC
extends Character

@onready var dialogueNode := $NPCDialogueNode

@export_group("Dialogue")
@export var onlyActivateOnce: bool
@export var dialogueArray: Array[DialogueArray]

var interactionIdx := 0
