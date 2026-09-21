@abstract class_name ComponentStats
extends ResourceGP

@export var is_multiplier : bool
var effects_handler : StatusEffectsHandler

func _register_values() -> Dictionary[StringName, Variant]:
	var values_return : Dictionary[StringName, Variant]
	for prop in get_property_list():
		var is_script_var: bool = prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE
		var is_exported: bool = prop.usage & PROPERTY_USAGE_EDITOR
		if is_script_var and is_exported:
			values_return.set(StringName(prop.name), get(prop.name))
	return values_return
