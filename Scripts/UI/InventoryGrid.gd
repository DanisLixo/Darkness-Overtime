extends GridContainer

var active := false

@export var categoryName: String
@export var invSize := 25
@export var defaultSize := Vector2(112, 120)

var selectedIndex := Vector2i(-1, -1)

## MOVER ESTA PUTA AO GLOBAL!@!!
var itemsLoad := ["PlaceholderBurger", "PlaceholderWhip"]

## Grid de items, itens que aparecem precisam aparecer em suas devidas categorias
func _ready() -> void:
	return
	
	for i in invSize:
		var newSlot := InventorySlot.new()
		newSlot.create(ItemData.ItemType.WEAPON, defaultSize)
		add_child(newSlot)
	
	for i in itemsLoad.size():
		var newItem := SlotItem.new()
		var itemData = load(get_item_data(itemsLoad[i]))
		newItem.create(itemData)
		get_child(i).add_child(newItem)
	
func get_item_data(itemName: String) -> String:
	var fullPath = "res://Resources/Items/"
	fullPath = fullPath.path_join(itemName + ".tres")
	return fullPath

signal opened
func open() -> void:
	active = true
	show()
	opened.emit()

signal closed
func close() -> void:
	active = false
	hide()
	closed.emit()
