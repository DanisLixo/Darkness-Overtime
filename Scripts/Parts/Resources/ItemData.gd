class_name ItemData
extends Resource

## Data de um item, utilize para Resources apenas!!!

enum ItemType {
	KEYS,
	ACCESSORY,
	CONSUMABLE,
	WEAPON
}

@export var itemId := 0
@export var itemType := ItemType.KEYS
@export var itemName := "placeholder"
@export_multiline var itemDescription: String
@export var spriteTexture: Texture2D
