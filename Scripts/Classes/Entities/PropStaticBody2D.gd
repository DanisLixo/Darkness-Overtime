@tool
class_name PropStaticBody2D
extends StaticBody2D

@export_group("Prop Properties", "prop")
@export var propTexture: Texture2D
@export var propOffset: Vector2

@export_group("Hitbox Properties", "hitbox")
@export var hitboxShape: Shape2D
@export var hitboxOffset: Vector2

@export var playerLayering := true

func _ready() -> void:
	$PlayerZIndexPerspective.active = playerLayering
	
	$Sprite2D.texture = propTexture
	$Sprite2D.offset = propOffset
	
	$CollisionShape2D.position = hitboxOffset
	$CollisionShape2D.shape = hitboxShape

func _process(delta: float) -> void:
	editor_stuff()

func editor_stuff() -> void:
	if (Engine.is_editor_hint()):
		$Sprite2D.texture = propTexture
		$Sprite2D.offset = propOffset
		$CollisionShape2D.position = hitboxOffset
		$CollisionShape2D.shape = hitboxShape
