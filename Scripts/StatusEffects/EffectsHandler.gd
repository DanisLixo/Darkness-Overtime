## Holds StatusEffects, gets called by anything using the trigger_event method.
class_name StatusEffectsHandler
extends Node

@onready var parent: Node2D = get_parent()

var effects: Dictionary[StatusEffect, StatusEffect.Priority]

enum ActionType {
	MOVE,
	JUMP,
	SHOOT,
	HIT_TAKEN,
	HIT_DEALT,
}

func update_effects(new_effects := []) -> void:
	for effect_resource: StatusEffectResource in new_effects:
		var effect : StatusEffect = effect_resource.effect.new()
		
		effect.time = effect_resource.time
		effect.extra_args = effect_resource.extra_args
		
		add_child(effect)
		effects.set(effect, effect.effect_priority)

func trigger_event(type: ActionType, is_post: bool, source : Node = null ,args: Dictionary = {}) -> void:
	for effect in effects:
		effect.on_event(type, is_post, source, args)
