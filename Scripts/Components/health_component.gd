## Health component, receives a function call to change their own health
extends Node
class_name HealthComponent

@export_range(0, 400) var max_health : int = 100
@export var hurtbox : Area2D
@export var effect_handler : StatusEffectsHandler

signal changed_health
signal killed
var current_health : int = max_health

func _ready() -> void:
	hurtbox.area_entered.connect(on_hitbox_entered.bind())

func on_hitbox_entered(area:Area2D):
	if area is HitboxComponent:
		change_health(area.damage)

func change_health(amount: int):
	current_health += amount
	if current_health <= 0:
		killed.emit()
		current_health = 0
		return
	if get_parent() is Player:
		EventBus.player_damaged.emit(current_health)
	changed_health.emit()
