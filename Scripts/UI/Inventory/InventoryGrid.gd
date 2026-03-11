class_name InventoryGrid extends GridContainer

@export var itemsAccepted: Array[ItemData.ItemType]
@export var invSize := 25
@export var defaultSize := Vector2(112, 120)

var items := []
var slots := []

var slotScene := preload("res://Scenes/Parts/InventorySlot.tscn")

## Grid de items, itens que aparecem precisam aparecer em suas devidas categorias
func _ready() -> void:
	get_items()
	generate_grid()

func generate_grid() -> void:
	var slotsArr: Array = []
	for i in invSize:
		var newSlot := slotScene.instantiate()
		
		if (i < items.size()):
			newSlot.myItem = items[i]
		
		add_child(newSlot)
		slotsArr.append(newSlot)
	
	for _i in slotsArr.size() / columns:
		slots.append([])
	var currentRow = 0
	for i in slotsArr.size():
		slots[currentRow].append(slotsArr[i])
		
		if (slots[currentRow].size() >= slotsArr.size() / columns):
			currentRow += 1

func get_items() -> void:
	for itemStr in Global.itemsLoad:
		var itemPath: String = get_item_data(itemStr)
		var itemData: ItemData = load(itemPath)
		
		if (itemData.itemType not in itemsAccepted):
			continue
		
		items.append(itemData)

func get_item_data(itemName: String) -> String:
	var fullPath = "res://Resources/Items/"
	fullPath = fullPath.path_join(itemName + ".tres")
	return fullPath
