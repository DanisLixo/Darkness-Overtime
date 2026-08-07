extends Control

const ITEM_HOLDER_SCENE := preload("res://Scenes/ItemHolder.tscn")
const INFO_LABEL_SCENE := preload("res://Scenes/shop_item_info_label.tscn")

var fullPrice := 0

func buy_items(itemArr = %ShopInfoList.cart_items) -> void:
	# for item in itemArr:
		# Player.money -= item.itemInfo.itemPrice
		# Player.inventory.append(item.itemID as ItemHandler.ID)
	
	clear_items()

func clear_items() -> void:
	var deleted := 0
	for item in %ShopInfoList.cart_items:
		deleted += 1
		item.free()
	
	%ShopInfoList.cart_items.clear()
	
	var items = %ShopInfoList.cart_items.size()
	print("%s deleted out of %s" % [str(deleted), str(items)])

func update_total() -> void:
	fullPrice = 0
	
	for i: ShopItemInfoLabel in %ShopInfoList.cart_items:
		fullPrice += i.itemInfo.itemPrice
	
	%Total.text = "Total - $%s" % fullPrice

func buy_pressed() -> void:
	# if (Player.money < fullPrice):
		# printerr("pode nao")
		# return
	
	buy_items()
	update_total()

func clear_all_pressed() -> void:
	clear_items()
	update_total()
