class_name ItemHandler extends Node

static var itemMap := []

enum ID {
	PLACEHOLDER_BURGER,
	PLACEHOLDER_KEY,
	PLACEHOLDER_WHIP,
}

static func get_item_data(itemId: int = 0) -> ItemData:
	return load("res://Resources/Items/" + itemMap[itemId] + ".tres")

static func update_item_id_map() -> void:
	itemMap.clear()
	
	var path := "res://Resources/ItemIDMap.json"
	var map := FileAccess.open(path, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(map.get_as_text())
	
	itemMap = json["ItemArray"]
