## A status effect abstract class, should be inherited for any custom effect.
class_name StatusEffect
extends Node

@onready var effects_handler: StatusEffectsHandler = get_parent()
@onready var parent := effects_handler.parent

enum Priority{
	ON_PICKUP = -1,
	ADDER = 0,
	MULTIPLIER = 1,
}

@export var effect_overrides : Array[StatusEffect]
@export var effect_priority : Priority = Priority.ON_PICKUP

var extra_args : Array
var timer := Timer.new()
var time: float

func _ready() -> void:
	if (time > 0.0):
		create_timer()
	
##Called each time an action gets called to StatusEffectsHandler
func on_event(type : StatusEffectsHandler.ActionType, is_post : bool , source : Node = null, args: Dictionary = {}) -> void:
	pass

func create_timer() -> void:
	add_child(timer)
	timer.start(time)
	timer.timeout.connect(end)

func end() -> void:
	queue_free()
