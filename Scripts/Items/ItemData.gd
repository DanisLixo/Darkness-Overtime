class_name ItemData
extends Resource

## Data de um item, utilize para Resources apenas!!!

enum ItemType {
	KEYS,
	ACCESSORY,
	CONSUMABLE,
	WEAPON
}

@export_category("Sprite")
@export var spriteTexture: Texture2D
@export var spritePortrait: Texture2D
@export var spriteShop: Texture2D

@export_category("General")
@export var itemType := ItemType.KEYS
@export var itemName := "placeholder"
@export_multiline var itemDescription: String

@export_category("Shop")
@export_range(0, 99999999) var itemPrice := 0

@export_category("Inventory")
@export_multiline var itemComment: String
@export var itemStats: Array[String]
