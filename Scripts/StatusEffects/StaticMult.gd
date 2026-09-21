##A template for StatusEffect subclasses
class_name StaticMult
extends StatusEffect

@export var static_multipliers : Array[ComponentStats]

func _init():
	effect_priority = Priority.MULTIPLY

func apply_static():
	for stat in static_multipliers:
		for prop in stat._register_values():
			if stat.get(prop) is not bool:
				effects_handler.value_statics["%s.%s" %[stat.get_script().get_global_name(), prop]] *= stat.get(prop) + 1.
