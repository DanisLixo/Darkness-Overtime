## Holds StatusEffects, gets called by anything using the trigger_event method.
##Class meant for storage and handling of status effects by override_action()
class_name StatusEffectsHandler
extends Node

signal effect_added(effect:StatusEffect)
signal effect_deleted(effect:StatusEffect)

@onready var parent: Node2D = get_parent()

var effects: Dictionary[StatusEffect, StringName]
var components : Dictionary[StringName, Node]

var value_defaults : Dictionary[StringName, Variant] = {
	"parent.scale": Vector2(1., 1.),
	"parent.modulate": Color(1.0, 1.0, 1.0, 1.0)
}
var value_statics : Dictionary[StringName, Variant]
var effect_overrides : Dictionary[StringName, Variant]

func _ready() -> void:
	_register_components.call_deferred()

func _physics_process(delta: float) -> void:
	for effect in effects:
		effect._tick(delta)

func _register_components():
	for node : Node in parent.get_children().filter(func(node): return !(node is StatusEffectsHandler)):
		if node.is_in_group(&"StatusAffectable"):
			assert(node.get_script().get_global_name() != &"", "%s must be declared with class_name!" %node.name)
			if "effects_handler" in node:
				node.effects_handler = self
				
			for prop in node.get_property_list():
				if node.get(prop.name) is ComponentStats:
					components.set(node.get_script().get_global_name(), node)
					for key in node.get(prop.name)._register_values():
						var new_key : StringName = StringName("%s.%s" %[node.get(prop.name).get_script().get_global_name(), key])
						value_defaults.set(new_key, node.get(prop.name)._register_values()[key])
			components.set(node.get_script().get_global_name(), node)
	
	_rebuild_static()

func update_effects(new_effects : Array[StatusEffect] = []) -> void:
	for effect in new_effects:
		var eff_copy = effect.duplicate(true)
		eff_copy.parent = parent
		eff_copy.effects_handler = self
		
		eff_copy._start()
		effects.set(eff_copy, eff_copy.effect_id)
		effect_added.emit(eff_copy)
		
	_rebuild_static()
		
func override_action(type: StatusEffect.ActionType) -> Dictionary[StringName, Variant]:
	effect_overrides = value_statics.duplicate(true)
	for effect in _sort_priority():
		effect.apply_dynamic(type)
	parent.scale = effect_overrides.get("parent.scale")
	parent.modulate = effect_overrides.get("parent.modulate")
	return effect_overrides

func delete_effect(effect:StatusEffect):
	effect_deleted.emit(effect)
	effects.erase(effect)
	_rebuild_static()

func _rebuild_static() -> void:
	value_statics = value_defaults.duplicate(true)
	for effect in _sort_priority():
		effect.apply_static()
func _sort_priority() -> Array[StatusEffect]:
	var _sorted_arr : Array[StatusEffect]
	_sorted_arr = effects.keys()
	
	_sorted_arr.sort_custom(func(a:StatusEffect, b:StatusEffect):
		return a.effect_priority < b.effect_priority
		)
	return _sorted_arr
