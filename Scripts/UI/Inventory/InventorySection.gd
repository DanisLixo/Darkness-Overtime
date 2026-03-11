extends Control

@export var inventoryGrid: InventoryGrid

@export var itemPortrait: TextureRect
@export var itemComment: Label
@export var itemMainInfo: Label

@export var minimumIdx := -1
var active = true

var currentSlot: InventorySlot
var selectedIndex := Vector2i(0, 0)

func _process(_delta: float) -> void:
	visible = active
	
	if (!active):
		selectedIndex.y = -1
	
	handle_inputs()
	
func handle_inputs() -> void:
	var directionX := int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	var directionY := int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))

	selectedIndex += Vector2i(directionX, directionY)
	
	selectedIndex.y = wrapi(selectedIndex.y, minimumIdx, inventoryGrid.slots.size())
	selectedIndex.x = wrapi(selectedIndex.x, 0, inventoryGrid.slots[selectedIndex.y].size())
	
	if (inventoryGrid.slots[selectedIndex.y][selectedIndex.x] != currentSlot):
		currentSlot = inventoryGrid.slots[selectedIndex.y][selectedIndex.x]
		update_item_info()
		
		handle_grid_activeness()
		currentSlot.grab_focus()
	
func update_item_info() -> void:
	var itemData: ItemData = currentSlot.myItem
	
	itemComment.text = ""
	itemMainInfo.text = ""
	itemPortrait.visible = (itemData != null)
	
	if (itemData == null):
		return
	
	var comment := "{ITEM_NAME}

	{ITEM_MESSAGE}"
	
	var main := "
	{ITEM_DESC}
	{ITEM_STATS}"
	
	itemComment.text = comment.replace("{ITEM_NAME}", itemData.itemName)
	itemComment.text = itemComment.text.replace("{ITEM_MESSAGE}", itemData.itemComment)
	
	itemMainInfo.text = main.replace("{ITEM_DESC}", itemData.itemDescription)
	
	var stats := ""
	for i in itemData.itemStats:
		stats += i + "\n"
	
	itemMainInfo.text = itemMainInfo.text.replace("{ITEM_STATS}", stats)
	
	if (itemData.spritePortrait != null):
		itemPortrait.texture = itemData.spritePortrait
	itemPortrait.visible = (itemData.spritePortrait != null)

func handle_grid_activeness() -> void:
	for i in inventoryGrid.slots.size():
		for j in inventoryGrid.slots[i].size():
			inventoryGrid.slots[j][i].selected = (active && currentSlot == inventoryGrid.slots[j][i])
