class_name Character
extends CharacterBody2D

var ANIMATIONS_FALLBACKS := {
	"walk": "idle"
}

enum INPUT {ACTION, RUN}
var inputDirection: Vector2
var keyPress: Array = [0, 0]
var keyHold: Array = [0, 0]

enum Direction {FRONT, BACK, LEFT, RIGHT}
var direction := Vector2i(0, 1)

@onready var sprite: DynamicAnimatedSprite2D = %Sprite
@onready var stateMachine: StateMachine = $States

@export_group("Character")
@export var characterName := "PlaceholderNPC"
@export var initialDirection := Character.Direction.FRONT
@export var asymetricalSprites := false

func _ready() -> void:
	sprite.update_sprites()
	sprite.direction = initialDirection
	sprite.change_to_idle()

func play_animation(animName: String = sprite.animation, speed := 1.0, backwards := false) -> void:
	var anim := get_animation(animName) + "_" + get_animation_direction()
	sprite.play(anim, speed, backwards)
	sprite.get_animation_offset(anim)

func get_animation(animName: String = "idle") -> String:
	if (!sprite.sprite_frames.has_animation(animName + "_" + get_animation_direction()) && ANIMATIONS_FALLBACKS.has(animName)):
		return get_animation(ANIMATIONS_FALLBACKS.get(animName))
	else:
		return animName

func get_animation_direction() -> String:
	var directionSprName := "front"
	if (direction.y != 0):
		if (direction.y == 1):
			directionSprName = "front"
		if (direction.y == -1):
			directionSprName = "back"
		if (asymetricalSprites):
			sprite.scale.x = direction.y
	elif (direction.x != 0):
		if (asymetricalSprites):
			sprite.scale.x = 1
			if (direction.x == -1):
				directionSprName = "left"
			else:
				directionSprName = "right"
		else:
			sprite.scale.x = direction.x
			directionSprName = "side"
	
	return directionSprName
