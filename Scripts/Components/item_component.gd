##ItemComponent, includes a StatusEffect and an Icon, should be paired with a Sprite2D
extends Area2D

@export var item_data : ItemData = ItemData.new()

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, true)
	set_collision_layer_value(6, true)
	body_entered.connect(on_body_entered.bind())
	add_to_group("Items")
	
func on_body_entered(body: CharacterBody2D) -> void:
	if "effects_handler" in body:
		body.effects_handler.add_item(item_data)
	get_parent().queue_free()
