class_name SpriteContainer
extends Node

var animated_sprites : Array[AnimatedSprite2D]
var sprites : Array[AnimatedSprite2D]

func _ready():
	for node in get_children():
		if node is AnimatedSprite2D:
			animated_sprites.append(node)
		elif node is Sprite2D:
			sprites.append(node)
