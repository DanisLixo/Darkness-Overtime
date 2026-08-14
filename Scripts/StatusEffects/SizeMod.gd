##A template for StatusEffect subclasses
extends StatusEffect
class_name SizeMod


func _ready() -> void:
	parent.size_mult += extra_args[0]
	pass

func _process(delta: float) -> void:
	pass

func on_event(type : StatusEffectsHandler.ActionType, is_post : bool , source : Node = null, args: Dictionary = {}) -> void:
	pass
