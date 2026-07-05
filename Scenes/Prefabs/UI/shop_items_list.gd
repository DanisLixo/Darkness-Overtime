extends GridContainer

var stockItems := [ItemHandler.ID.PLACEHOLDER_BURGER, ItemHandler.ID.PLACEHOLDER_KEY]

func _ready() -> void:
	create_stock()
	
func create_stock() -> void:
	for id in stockItems:
		var newHolder: ItemHolder = owner.ITEM_HOLDER_SCENE.instantiate()
		
		newHolder.itemID = stockItems[id]
		newHolder.selected.connect(on_item_selected)
		
		add_child(newHolder)

func on_item_selected(this: ItemHolder) -> void:
	%ShopInfoList.add_to_cart(this)
