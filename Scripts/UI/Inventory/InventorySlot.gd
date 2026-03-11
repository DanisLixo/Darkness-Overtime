class_name InventorySlot
extends TextureRect

@export var selectedTexture: Texture2D = preload("res://Assets/Sprites/UI/Inventory/Grid/GridTileSelected.png")
@export var disabledTexture: Texture2D = preload("res://Assets/Sprites/UI/Inventory/Grid/GridTile.png")

var selected := false
var myItem: ItemData

signal gotSelected(gridSpace: InventorySlot)

func _enter_tree() -> void:
	$ItemImage.create(myItem)
	$Button.pressed.connect(
		func() -> void: 
			selected = true 
			gotSelected.emit(self)
	)

func _process(_delta: float) -> void:
	texture = selectedTexture if selected else disabledTexture
