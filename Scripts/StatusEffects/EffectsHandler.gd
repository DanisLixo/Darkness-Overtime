## Holds StatusEffects, should be used by nodes that uses the apply_effects() method.
class_name StatusEffectsHandler
extends Node

@onready var parent: Node2D = get_parent()

var effects: Array[StatusEffect] = []

func update_effects(new_effects := []) -> void:
	for effect_resource: StatusEffectResource in new_effects:
		var effect := StatusEffect.new()
		
		effect.effect = effect_resource.effect
		effect.time = effect_resource.time
		effect.extra_args = effect_resource.extra_args
		effects = EffectsMethods.update_effects(effect, effects, effect_resource.override_related)
		
		add_child(effect)
		effects.append(effect)

func apply_effects() -> void:
	for effect in effects:
		effect.apply()

func get_effect(effect := StatusEffect.Effect.NONE) -> StatusEffect:
	for i in effects:
		if i.effect == effect:
			return i
	return null

func has_effect(effect := StatusEffect.Effect.NONE) -> bool:
	for i in effects:
		if i.effect == effect:
			return true
	return false
