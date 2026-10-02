##ItemData Resource, contains all data needed for an item
class_name ItemData
extends Resource

enum ItemType {
	PASSIVE,
	ACTIVE,
}
enum LimbType{
	HEAD = 1,
	TORSO = 2,
	LEFT_LEG = 4,
	RIGHT_LEG = 8,
	LEFT_ARM = 16,
	RIGHT_ARM = 32
}
@export_range(0, INT16_MAX) var item_id : int
@export var item_type : ItemType = ItemType.PASSIVE
@export_multiline var item_description: String
@export var sprite_texture: Texture2D
@export var sprite_portrait: Texture2D
@export var sprite_shop: Texture2D
@export_flags("Head:1", "Torso:2", "Left Leg:4", "Right Leg:8", "Left Arm:16", "Right Arm:32")
var compatible_limbs : int
@export var status_effects: Array[StatusEffect]
@export_range(0, INT64_MAX) var item_price := 0
@export_multiline var item_comment: String
