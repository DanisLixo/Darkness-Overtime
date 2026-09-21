## Holds the methods of all the Status Effects.
class_name EffectsMethods
extends Object

static var effects_overrides : Dictionary[StatusEffect.Effect, StatusEffect.Effect]= {
	StatusEffect.Effect.TURN_SMALL: StatusEffect.Effect.TURN_BIG,
	StatusEffect.Effect.TURN_BIG: StatusEffect.Effect.TURN_SMALL
}
static var not_effect_method := ["update_effects", "get_effect_method"]

## Update the effects given inside effects_arr. returns the array modified and free refreshed/overwritten effects.
static func update_effects(effect_to_compare: StatusEffect, effects_arr: Array, override_related := false) -> Array:
	for i in effects_arr:
		if (i.effect == effect_to_compare.effect):
			i.end()
		
		if (override_related && effects_overrides.has(effect_to_compare.effect)):
			if (i.effect == effects_overrides[effect_to_compare.effect]):
				effects_arr.erase(i)
				i.end()
	
	return effects_arr

## Returns the method of the effect. No effect has a declarable name yet.
static func get_effect_method(effect_enum := StatusEffect.Effect.NONE) -> String:
	if (StatusEffect.METHODS_ARRAY.is_empty()):
		var methods_list = EffectsMethods.new().get_script().get_script_method_list()
		
		for method in methods_list:
			if (!not_effect_method.has(method["name"])):
				StatusEffect.METHODS_ARRAY.append(method["name"])
		
		print(str(StatusEffect.METHODS_ARRAY))
	
	return StatusEffect.METHODS_ARRAY[effect_enum]

## Normalize the given Vector2 to a normalized self.
func normalize_vector(object: PhysicsBody2D, eat_inputs : bool = false, vector_variable : String = "input_direction") -> void:
	var vector = object.get(vector_variable)
	
	if (object.get(vector_variable) is Vector2):
		object.set(vector_variable, vector.normalized())
		if (eat_inputs && randi_range(0, 99) >= 74):
			var stop_time := randi_range(0, 99) < 80
			while stop_time:
				stop_time = randi_range(0, 99) < 80
				
				object.set(vector_variable, Vector2i.ZERO) 
				# Jokes haha funny it eats your inputs...... sigh.
				await object.get_tree().process_frame 
				object.set(vector_variable, Vector2i.ZERO)

## Modifies running speed, can be abragent to modify the whole physics dict.
func run_speed_modifier(object: PhysicsBody2D, mult := 2.0) -> void:
	if (object.get("physics") != null):
		object.physics.RUN_ACCEL = object.BASE_PHYSICS.RUN_ACCEL * mult
		object.physics.RUN_MAX_SPEED = object.BASE_PHYSICS.RUN_MAX_SPEED * mult

## Turns the object smaller than it's original size, should be used for values smaller than one.
func turn_small(object: PhysicsBody2D, mult := 0.5) -> void:
	if (object.size_mult >= mult * 2):
		object.size_mult *= mult

## Turns the object bigger than it's original size, should be used for values bigger than one.
func turn_big(object: PhysicsBody2D, mult := 2.0) -> void:
	if (object.size_mult <= mult / 2):
		object.size_mult *= mult
