@tool
## From the prior RPG, currently, this has no actual use.
## Serves as the parent for other Area Functions, it will only detect the player. 
## Should have an CollisionShape2D attached if not done automatically by the object itself. 
class_name AreaTrigger2D
extends PlayerDetectorArea2D

@export var collisionShape: Shape2D: set = update_shape
var collisionObject: CollisionShape2D


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
	check_existent_collision()
