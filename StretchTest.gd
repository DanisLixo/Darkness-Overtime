extends Node2D

# TODO: Apply this to a new player sprite.

var velocity := Vector2.ZERO

@onready var head: Sprite2D = %Head
@onready var body: Sprite2D = %Body

func _process(delta: float) -> void:
	var player := Global.players[0]
	
	velocity.x = player.velocity.x
	velocity.y = player.velocity.y
	
	streatch(delta)

## Not how it's written.
func streatch(delta: float) -> void:
	var player := Global.players[0]
	head.position = player.velocity / 10
	body.position = player.velocity / 20
