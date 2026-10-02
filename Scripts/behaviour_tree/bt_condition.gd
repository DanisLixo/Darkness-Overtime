@tool
class_name BTCondition
extends BehaviorTree

enum Operator {
	EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL
}

var operator_callables : Dictionary[Operator, Callable] = {
	Operator.EQUAL: func(a, b) -> bool: return a == b,
	Operator.NOT_EQUAL: func(a, b) -> bool: return a != b,
	Operator.LESS: func(a, b) -> bool: return a < b,
	Operator.LESS_EQUAL: func(a, b) -> bool: return a <= b,
	Operator.GREATER: func(a, b) -> bool: return a > b,
	Operator.GREATER_EQUAL: func(a, b) -> bool: return a >= b,
}

@export var node : Node:
	set(new_value):
		node = new_value
@export var operator : Operator = Operator.EQUAL
@export var variable : StringName: 
	set(new_value):
		variable = new_value
		_variable_changed()

var truthy_value : Variant

@export_storage var var_hint_string : String = ""
@export_storage var var_hint : PropertyHint
@export_storage var var_type : int = -1
@export_storage var script_var : Dictionary

func _tick(delta : float) -> TickReturn:
	if node:
		if operator_callables[operator].call(node.get(variable), truthy_value):
			return TickReturn.SUCCESS
	return TickReturn.FAILURE

func _variable_changed() -> void:
	if variable == &"":
		_clear_variable_info()
		return
	if not node:
		return

	var info := get_script_var(node, variable)

	if !info.is_empty():
		var new_type : int = info[&"type"]
		if new_type != var_type:
			truthy_value = null if new_type == TYPE_NIL else type_convert(null, new_type)
		var_type = new_type
		var_hint = info[&"hint"]
		var_hint_string = info[&"hint_string"]

		if new_type == TYPE_OBJECT and var_hint == PROPERTY_HINT_NONE:
			var cls : String = info[&"class_name"]
			if cls != "":
				var_hint_string = cls
				var_hint = PROPERTY_HINT_NODE_TYPE if _is_node_class(cls) \
						else PROPERTY_HINT_RESOURCE_TYPE
		notify_property_list_changed()


func _clear_variable_info() -> void:
	var_type = -1
	var_hint = PROPERTY_HINT_NONE
	var_hint_string = ""
	truthy_value = null
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var property_list : Array[Dictionary] = []
	if var_type != -1:
		var usage := PROPERTY_USAGE_DEFAULT
		if var_type == TYPE_NIL:
			usage |= PROPERTY_USAGE_NIL_IS_VARIANT
		property_list.append({
			"name": "truthy_value",
			"type": var_type,
			"usage": usage,
			"hint": var_hint,
			"hint_string": var_hint_string,
		})

	return property_list

func get_script_var(node_to_eval: Object, var_name: StringName) -> Dictionary:
	var script: Script = node_to_eval.get_script()
	if script:
		var found_value : Array[Dictionary] = script.get_script_property_list().filter(func(p):
			return p.name == var_name)
		if !found_value.is_empty():
			print(found_value[0])
			return found_value[0]
	return {}

func _is_node_class(cls : String) -> bool:
	if ClassDB.class_exists(cls):
		return ClassDB.is_parent_class(cls, &"Node")
	for c in ProjectSettings.get_global_class_list():
		if c.class == cls:
			var base : String = c.base
			return base == "Node" or _is_node_class(base)
	return false
