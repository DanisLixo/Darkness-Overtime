extends State

@export var roam_time : float = 5
var roam_timer : Timer
var roam_tween : Tween
var last_location : Vector2 = Vector2(1, 1)

@onready var sprite = parent.sprite as AnimatedSprite2D
@onready var movement_component = parent.movement_component as MovementComponent

func _ready() -> void:
	roam_timer = Timer.new()
	roam_timer.timeout.connect(move_around)
	add_child(roam_timer)
	
func move_around() -> void:
	var random_location = Vector2(randf_range(-250, 250) * last_location.sign().x, randf_range(-250, 250) * last_location.sign().y)
	sprite.play("walk_front")
	roam_tween = movement_component.move_tween(parent.global_position + random_location, false)
	roam_tween.finished.connect(stop_moving)
	roam_timer.start(roam_time)
	last_location = random_location
	
func stop_moving():
	sprite.stop()

func exit(_msg = {}) -> void:
	roam_timer.stop()
	if roam_tween != null:
		roam_tween.stop()
	
func enter(_msg = {}) -> void:
	roam_timer.start(roam_time / 2.)
