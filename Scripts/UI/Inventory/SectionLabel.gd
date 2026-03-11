extends TextureRect

@export var selected := false
@export var selectedTexture: Texture
@export var disabledTexture: Texture

func _process(delta: float) -> void:
	texture = selectedTexture if selected else disabledTexture
