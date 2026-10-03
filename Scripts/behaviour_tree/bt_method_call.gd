@tool
class_name BTMethodCall
extends BehaviorTree

@export var node : Node
@export var method : StringName:
	set(new_value):
		method = new_value
		_method_changed()

@export_storage var arg_infos : Array[Dictionary] = []
@export_storage var arg_values : Dictionary = {}


func _tick(delta : float) -> TickReturn:
	if node and node.has_method(method):
		var args : Array = arg_infos.map(func(a): return arg_values[a.name])
		node.callv(method, args)
		return TickReturn.SUCCESS
	return TickReturn.FAILURE

func _method_changed() -> void:
	arg_infos = []
	arg_values = {}

	if node and method != &"":
		for m in node.get_method_list():
			if m.name != method:
				continue
			arg_infos.assign(m.args)
			for i in m.args.size():
				var a : Dictionary = m.args[i]
				if has_arg_default(m, i):
					set("arguments/" + a.name, get_arg_default(m, i))
					arg_values["arguments/" + a.name] = get_arg_default(m, i)
				else:
					arg_values[a.name] = null if a.type == TYPE_NIL else type_convert(null, a.type)
			break
			
	if !arg_infos.is_empty() or method == &"":
		notify_property_list_changed()
		
	for m in node.get_method_list():
		if m.name != method:
			continue
		
	if !arg_infos.is_empty() or method == &"":
		notify_property_list_changed()

func _build_arg_info(a : Dictionary) -> Dictionary:
	var info := {
		&"name": a.name,
		&"type": a.type,
		&"hint": a.hint,
		&"hint_string": a.hint_string,
	}
	if a.type == TYPE_OBJECT and a.hint == PROPERTY_HINT_NONE and a.class_name != &"":
		info.hint_string = a.class_name
		info.hint = PROPERTY_HINT_NODE_TYPE if _is_node_class(a.class_name) \
				else PROPERTY_HINT_RESOURCE_TYPE
	return info


func _get_property_list() -> Array[Dictionary]:
	var list : Array[Dictionary] = []
	for info in arg_infos:
		var usage := PROPERTY_USAGE_EDITOR
		if info.type == TYPE_NIL:
			usage |= PROPERTY_USAGE_NIL_IS_VARIANT
		list.append({
			"name": "arguments/" + info.name,
			"type": info.type,
			"usage": usage,
			"hint": info.hint,
			"hint_string": info.hint_string,
		})
	return list

func _is_node_class(cls : String) -> bool:
	if ClassDB.class_exists(cls):
		return ClassDB.is_parent_class(cls, &"Node")
	for c in ProjectSettings.get_global_class_list():
		if c.class == cls:
			var base : String = c.base
			return base == "Node" or _is_node_class(base)
	return false
	
func get_method_info(obj : Object, method_name : StringName) -> Dictionary:
	for m in obj.get_method_list():
		if m.name == method_name:
			return m
	return {}

func has_arg_default(m : Dictionary, i : int) -> bool:
	return i >= m.args.size() - m.default_args.size()

func get_arg_default(m : Dictionary, i : int) -> Variant:
	var first_default : int = m.args.size() - m.default_args.size()
	if i < first_default:
		return null
	return m.default_args[i - first_default]
	
func _get(property : StringName) -> Variant:
	if property.begins_with("arguments/"):
		return arg_values.get(property.trim_prefix("arguments/"))
	return null

func _set(property : StringName, value : Variant) -> bool:
	if property.begins_with("arguments/"):
		arg_values[property.trim_prefix("arguments/")] = value
		return true
	return false
