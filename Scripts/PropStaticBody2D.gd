@tool
## Used for 2D Props.
class_name PropStaticBody2D
extends StaticBody2D

@export_group("Prop Properties", "prop")
## Texture of the prop.
@export var propTexture: Texture2D
## Offset of the prop.
@export var propOffset: Vector2

@export_group("Hitbox Properties", "hitbox")
## Shape of the hitbox that interacts with the player. If you don't want the prop to have a hitbox just leave this unset.
@export var hitboxShape: Shape2D
## Offset of the hitbox. If you don't want the prop to have a hitbox just leave shape unset.
@export var hitboxOffset: Vector2

## Activates layering with the player. If disabled, the layering will work depending on the prop's actual z-index.
@export var playerLayering := true

func _ready() -> void:
	$PlayerZIndexPerspective.active = playerLayering
	
	$Sprite2D.texture = propTexture
	$Sprite2D.offset = propOffset
	
	$CollisionShape2D.position = propOffset + hitboxOffset
	$CollisionShape2D.shape = hitboxShape

func _process(delta: float) -> void:
	if (Engine.is_editor_hint()): editor_stuff()

func editor_stuff() -> void:
	$Sprite2D.texture = propTexture
	$Sprite2D.offset = propOffset
	$CollisionShape2D.position = propOffset + hitboxOffset
	$CollisionShape2D.shape = hitboxShape
