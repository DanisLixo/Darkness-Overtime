##ItemComponent, includes a StatusEffectResource and an Icon, should be paired with a Sprite2D and a PlayerDetectorArea
class_name ItemComponent
extends Area2D

@export var effects: Array[StatusEffectResource]
@export var icon: Texture2D = preload("res://AssetsOld/Sprites/UI/Items/PlaceholderBurger/Icon.png")

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, true)
	body_entered.connect(on_player_entered.bind())
	add_to_group("Items")
	
func on_player_entered(player: Player) -> void:
	player.effects_handler.update_effects(effects)
	get_parent().queue_free()
