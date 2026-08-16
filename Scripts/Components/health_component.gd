## Health component, receives a function call to change their own health
extends Node
class_name HealthComponent

@export_range(0, 400) var max_health : int = 100
@export var hurtbox : Area2D
@export var effect_handler : StatusEffectsHandler
@export var i_frames : int = Engine.max_fps

signal changed_health
signal killed
var current_health : int = max_health

func _ready() -> void:
	hurtbox.area_entered.connect(on_bullet_entered.bind())

func on_bullet_entered(area:Area2D):
	if !(area.get_parent() is Player):
		area.get_parent().explode()
		change_health(-10)

func change_health(amount: int):
	current_health += amount
	if current_health < 0:
		killed.emit()
		current_health = 0
	changed_health.emit()
