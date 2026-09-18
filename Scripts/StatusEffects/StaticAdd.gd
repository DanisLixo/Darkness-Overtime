##This effect encapsulates any and all static additions
class_name StaticAdd
extends StatusEffect

@export var values : Dictionary[StringName, Variant]

func _tick(delta:float):
	super(delta)
	pass

func apply_static():
	for key in values:
		assert(key in effects_handler.value_defaults, "ERROR: %s not found in %s, did you mean %s?" % [key, parent, get_similar_value(key, effects_handler.value_defaults.keys())])
		if values[key] is not bool:
			effects_handler.value_statics[key] += values[key]
		else:
			effects_handler.value_statics[key] = values[key] if effects_handler.value_statics[key] == false else false

func get_similar_value(string : StringName, string_arr : Array[StringName]) -> StringName:
	var best_match: String = ""
	var highest_score: float = -1.0

	for candidate in string_arr:
		var score = string.similarity(candidate)
		if score > highest_score:
			highest_score = score
			best_match = candidate
			
	return best_match
