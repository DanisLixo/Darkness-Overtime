class_name InventorySlot
extends PanelContainer

@export var itemType: ItemData.ItemType

## Dane-se!
func create(t: ItemData.ItemType, customMinimumSize: Vector2):
	itemType = t
	custom_minimum_size = customMinimumSize
	
