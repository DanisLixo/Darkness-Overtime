class_name InventorySlot
extends PanelContainer

@export var itemType: ItemData.ItemType
@export var selectedTexture: Texture2D

var selected := false

func _enter_tree() -> void:
	custom_minimum_size = Vector2i(80,79)

## Dane-se!
func create(t: ItemData.ItemType, customMinimumSize: Vector2):
	itemType = t
	custom_minimum_size = customMinimumSize
	
