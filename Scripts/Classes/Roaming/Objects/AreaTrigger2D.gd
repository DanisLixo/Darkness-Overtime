@tool
class_name AreaTrigger2D
extends Area2D

@export var collisionShape: Shape2D: set = update_shape
var collisionObject: CollisionShape2D

var playerIn := false

func update_shape(value: Shape2D) -> void:
	collisionShape = value
	
	check_existent_collision()
	collisionObject.shape = collisionShape

func check_existent_collision() -> void:
	collisionObject = get_node_or_null("CollisionShape2D")
	
	if (collisionObject == null):
		var col := CollisionShape2D.new()
		col.name = "CollisionShape2D"
		add_child(col)
		
		collisionObject = col
	
	collisionObject.item_rect_changed.connect(update_shape)

func _ready() -> void:
	area_entered.connect(player_entered)
	area_exited.connect(player_exited)
	
	check_existent_collision()

func player_entered(playerArea: Area2D) -> void:
	if (playerArea.owner is Player):
		playerIn = true
		
func player_exited(playerArea: Area2D) -> void:
	if (playerArea.owner is Player):
		playerIn = false
