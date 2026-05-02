extends Control

@onready var wireframer: TextureRect = $Wireframe
@onready var items := wireframer.get_children()
@export var invSection: Control

func _process(_delta: float) -> void:
	var itemName: String = ""
	if (invSection.currentSlot != null && invSection.currentSlot.myItem != null):
		itemName = invSection.currentSlot.myItem.itemName.replace(" ", "")
	
	for item in items:
		item.visible = (item.name == itemName)
