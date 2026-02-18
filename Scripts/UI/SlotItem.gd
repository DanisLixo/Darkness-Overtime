class_name SlotItem
extends TextureRect

@export var itemData: ItemData

## Faz o item em si aparecer nos slots do menu de inventario. O jeito que as informacoes aparecem vai mudar.
func create(d: ItemData) -> void:
	itemData = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = itemData.spriteTexture
	tooltip_text = "%s\n%s" % [itemData.itemName, itemData.itemDescription]

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
