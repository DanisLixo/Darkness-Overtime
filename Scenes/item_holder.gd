class_name ItemHolder extends Control

## TODO: Add back ItemsHandler from the "scrapped-rpg" branch.

@export var itemID = 0 #: ItemHandler.ID = ItemHandler.ID.PLACEHOLDER_BURGER

var itemInfo: ItemData

signal selected(this: ItemHolder)

func _ready() -> void:
	# itemInfo = ItemHandler.get_item_data(itemID)
	
	update()

func update() -> void:
	%Price.text = "$" + str(itemInfo.itemPrice)
	%ItemIcon.create(itemInfo)

func _selected() -> void:
	selected.emit(self)
