##This effect encapsulates any and all static additions + multiplications
class_name StaticMod
extends StatusEffect

@export var speed_mod : float = 0.

func _tick(delta:float):
	super(delta)
	pass

func apply_static():
	effects_handler.value_statics[&"MovementComponent.speed"] += speed_mod
	effects_handler.value_statics[&"MovementComponent.sprint_speed"] += speed_mod
