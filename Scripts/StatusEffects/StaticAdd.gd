##This effect encapsulates any and all static additions + multiplications
class_name StaticAdd
extends StatusEffect

#To prevent over abstracting the effects more than they are, 
#it's recommended to make an export_group with the 
#component's names and variables to set, preferrable over a StringName dictionary
@export_group("MovementComponent")
@export var speed_mod : float = 0.

func _tick(delta:float):
	super(delta)
	pass

func apply_static():
	effects_handler.value_statics[&"MovementComponent.speed"] += speed_mod
	effects_handler.value_statics[&"MovementComponent.sprint_speed"] += speed_mod
