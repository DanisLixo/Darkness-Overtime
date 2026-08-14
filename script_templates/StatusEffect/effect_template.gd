##A template for StatusEffect subclasses
extends StatusEffect

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	pass

func on_event(type : StatusEffectsHandler.ActionType, is_post : bool , source : Node = null, args: Dictionary = {}) -> void:
	pass
