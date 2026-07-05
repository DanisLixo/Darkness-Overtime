extends VBoxContainer

var cart_items := []

func add_to_cart(item: ItemHolder) -> void:
	var new_item: ShopItemInfoLabel = owner.INFO_LABEL_SCENE.instantiate()
	
	new_item.myHolder = item
	new_item.unlist.connect(remove_from_cart)
	
	cart_items.push_back(new_item)
	add_child(new_item)
	
	owner.update_total()

func remove_from_cart(infoLabel: ShopItemInfoLabel) -> void:
	infoLabel.queue_free()
	cart_items.erase(infoLabel)
	
	owner.update_total()
