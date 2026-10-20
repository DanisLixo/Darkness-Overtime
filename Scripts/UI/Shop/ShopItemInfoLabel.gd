class_name ShopItemInfoLabel extends HBoxContainer

@export var myHolder: ItemHolder

var itemID := -1
var itemInfo: ItemResource

signal unlist(me: ShopItemInfoLabel)

func _ready() -> void:
	update()

func update() -> void:
	# if (myHolder != null):
		# itemInfo = ItemHandler.get_item_data(myHolder.itemID)
	
	%ItemName.text = itemInfo.itemName
	%Price.text = "$" + str(itemInfo.itemPrice)

func unlist_pressed() -> void:
	unlist.emit(self)
