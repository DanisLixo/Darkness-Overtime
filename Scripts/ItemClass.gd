class_name Item
extends CharacterBody2D

@export var effects: Array[StatusEffectResource]
@export var texture: Texture2D = preload("res://AssetsOld/Sprites/UI/Items/PlaceholderBurger/Icon.png")

func _ready() -> void:
	$Sprite2D.texture = texture

func on_player_entered(player: Player) -> void:
	player.effects_handler.update_effects(effects)
	
	queue_free()
