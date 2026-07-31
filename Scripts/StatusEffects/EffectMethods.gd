class_name EffectsMethods
extends Object

static var effects_overrides := {
	StatusEffect.Effect.TURN_SMALL: StatusEffect.Effect.TURN_BIG,
	StatusEffect.Effect.TURN_BIG: StatusEffect.Effect.TURN_SMALL
}
static var not_effect_method := ["update_effects", "get_effect_method"]

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
	if (StatusEffect.METHODS_ARRAY.is_empty()):
		var methods_list = EffectsMethods.new().get_script().get_script_method_list()
		
		for method in methods_list:
			if (!not_effect_method.has(method["name"])):
				StatusEffect.METHODS_ARRAY.append(method["name"])
		
		print(str(StatusEffect.METHODS_ARRAY))
	
	return StatusEffect.METHODS_ARRAY[effect_enum]

func normalize_direction(object: PhysicsBody2D, eat_inputs := false) -> void:
	if (object.get("input_direction") != null):
		object.input_direction = object.input_direction.normalized()
		if (eat_inputs && randi_range(0, 99) >= 74):
			var stop_time := randi_range(0, 99) < 80
			while stop_time:
				stop_time = randi_range(0, 99) < 80
				
				object.input_direction = Vector2i.ZERO
				
				await object.get_tree().process_frame
				object.input_direction = Vector2i.ZERO

func double_speed(object: PhysicsBody2D, mult := 2.0) -> void:
	if (object.get("physics") != null):
		object.physics.RUN_ACCEL = object.BASE_PHYSICS.RUN_ACCEL * mult
		object.physics.RUN_MAX_SPEED = object.BASE_PHYSICS.RUN_MAX_SPEED * mult

func turn_small(object: PhysicsBody2D, mult := 0.5) -> void:
	if (object.size_mult >= mult * 2):
		object.size_mult *= mult

func turn_big(object: PhysicsBody2D, mult := 2.0) -> void:
	if (object.size_mult <= mult / 2):
		object.size_mult *= mult
