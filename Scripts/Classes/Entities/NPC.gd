class_name GenericNPC
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var stateMachine: StateMachine = $States
@onready var dialogueNode := $NPCDialogueNode

@export var onlyActivateOnce: bool
@export var overrideDialoguePosition: bool
@export var overridePosition: Vector2
@export var dialogueArray: Array[DialogueArray]

var direction: Vector2i
var interactionIdx := 0

enum INPUT {
	ACTION,
	RUN
}

var inputDirection: Vector2
var keyPress: Array = [0, 0]
var keyHold: Array = [0, 0]

var character := "Placeholder"

func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Players")
	if (player != null):
		z_index = (player.z_index - 1) + int(global_position.y > player.global_position.y)
	
	handle_animations()

func handle_animations() -> void:
	handle_animation_direction()
	if (inputDirection):
		sprite.animation = sprName + "_" + directionSprName
	else:
		sprite.animation = sprName + "_" + directionSprName
	
	sprite.play()

var sprName: String = "idle"
var directionSprName: String = "front"
func handle_animation_direction() -> void:
	
	if (direction.y == 1):
		directionSprName = "front"
	if (direction.y == -1):
		directionSprName = "back"
	elif (direction.x != 0):
		directionSprName = "side"
		if (direction.x != 0):
			sprite.scale.x = -direction.x
		else:
			sprite.scale.x = 1
