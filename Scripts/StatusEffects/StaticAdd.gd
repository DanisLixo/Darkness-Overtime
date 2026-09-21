##This effect encapsulates any and all static additions
class_name StaticAdd
extends StatusEffect

@export var static_additions : Array[ComponentStats]
func _init():
	effect_priority = Priority.ADD
func apply_static():
	for stat in static_additions:
		for prop in stat._register_values():
			if stat.get(prop) is not bool:
				effects_handler.value_statics["%s.%s" %[stat.get_script().get_global_name(), prop]] += stat.get(prop)
