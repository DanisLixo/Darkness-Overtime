class_name StatusEffect
extends Node

static var METHODS_ARRAY := []
enum Effect {
	NONE = -1,
	VECTOR_NORMALIZER = 0,
	DOUBLE_SPEED,
	TURN_SMALL,
	TURN_BIG
}

var effect_call := EffectsMethods.new()

@onready var effects_handler: StatusEffectsHandler = get_parent()
@onready var parent := effects_handler.parent

var effect: Effect
var effect_method: String

var timer := Timer.new()
var time: float

var extra_args: Array[Variant]

func _ready() -> void:
	effect_method = EffectsMethods.get_effect_method(effect)
	
	if (time > 0.0):
		create_timer()

func apply() -> void:
	var args := [parent]
	args.append_array(extra_args)
	
	effect_call.callv(effect_method, args)

func create_timer() -> void:
	add_child(timer)
		
	timer.start(time)
	timer.timeout.connect(on_timeout)

func on_timeout() -> void:
	effects_handler.effects.erase(self)
	queue_free()

func end() -> void:
	effects_handler.effects.erase(self)
	queue_free()
