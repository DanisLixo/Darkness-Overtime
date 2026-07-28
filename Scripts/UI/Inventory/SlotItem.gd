class_name SlotItem
extends TextureRect

enum IconMode {
	STORED,
	PORTRAIT,
	SHOP
}

@export var iconMode := IconMode.STORED
@export var itemData: ItemData:
	set(value):
		itemData = value
		get_and_set_texture()

## Faz o item em si aparecer nos slots do menu de inventario. O jeito que as informacoes aparecem vai mudar.
func create(d: ItemData) -> void:
	itemData = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2) -> Control:
	var t = TextureRect.new()
	t.texture = texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = Vector2(300, 150)
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	
	var c = Control.new()
	c.add_child(t)
	
	return c

func get_and_set_texture() -> void:
	if (itemData != null && itemData.spriteTexture != null):
		match (iconMode):
			IconMode.STORED:
				texture = itemData.spriteTexture
			IconMode.PORTRAIT:
				texture = itemData.spritePortrait
			IconMode.SHOP:
				texture = itemData.spriteShop
	else:
		printerr("Item is null, nothing to use.")
