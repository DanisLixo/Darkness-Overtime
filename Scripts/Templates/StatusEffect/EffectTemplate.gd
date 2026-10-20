##A template for StatusEffect subclasses
extends StatusEffect

func _start() -> void:
	super()
	pass

func _tick(delta:float) -> void:
	super(delta)
	pass

func apply_static() -> void:
	pass

func apply_dynamic(type:ActionType) -> void:
	pass

func _on_action_performed(type:ActionType) -> void:
	pass
