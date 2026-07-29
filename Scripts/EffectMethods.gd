class_name EffectsMethods
extends Object

const METHODS_ARRAY := ["normalize_direction", "double_speed", "turn_small", "turn_big"]

static var effects_overrides := {
	StatusEffect.Effect.TURN_SMALL: StatusEffect.Effect.TURN_BIG,
	StatusEffect.Effect.TURN_BIG: StatusEffect.Effect.TURN_SMALL
}

static func update_effects(effect_to_compare: StatusEffect, effects_arr: Array, override_related := false) -> Array:
	for i in effects_arr:
		if (i.effect == effect_to_compare.effect):
			i.end()
		
		if (override_related && effects_overrides.has(effect_to_compare.effect)):
			if (i.effect == effects_overrides[effect_to_compare.effect]):
				effects_arr.erase(i)
				i.end()
	
	return effects_arr

static func get_effect_method(effect_enum := StatusEffect.Effect.NONE) -> String:
	return METHODS_ARRAY[effect_enum]

func normalize_direction(object: PhysicsBody2D) -> void:
	if (object.get("input_direction") != null):
		object.input_direction = object.input_direction.normalized()

func double_speed(object: PhysicsBody2D) -> void:
	if (object.get("physics") != null):
		object.physics.RUN_ACCEL = object.BASE_PHYSICS.RUN_ACCEL * 2
		object.physics.RUN_MAX_SPEED = object.BASE_PHYSICS.RUN_MAX_SPEED * 2

func turn_small(object: PhysicsBody2D) -> void:
	if (object.size_mult >= 1):
		object.size_mult *= 0.5

func turn_big(object: PhysicsBody2D) -> void:
	if (object.size_mult <= 1):
		object.size_mult *= 2
