## A status effect abstract class, should be inherited for any custom effect.
@abstract class_name StatusEffect
extends ResourceGP

var effects_handler : StatusEffectsHandler
var parent : Node2D
var effect_id : StringName = StringName(get_script().get_global_name())

enum ActionType {
	MOVE,
	JUMP,
	SHOOT,
	HIT_TAKEN,
	HIT_DEALT,
}

enum Priority{
	ADD,
	MULTIPLY,
	REACT,
}

@export var effect_overrides : Array[StatusEffect]
@export var effect_priority : Priority = Priority.ADD
@export var time : float
var time_remaining : float = time

func _start() -> void:
	time_remaining = time

func end():
	effects_handler.delete_effect(self)
	
##Gets ticked every _physics_process() frame
func _tick(delta:float):
	if time != 0:
		time_remaining -= delta
		if time_remaining <= 0:
			end()

##Gets called iteratively each time override_action gets called on StatusEffectsHandler, 
##meant to modify actions as they're happening
func apply_dynamic(type : ActionType):
	pass

##Gets called once when it gets added and value_statics gets rebuilt
func apply_static():
	pass

##Gets called by signals, meant for more reactionary (and non-compounding) effects than overrides
func _on_action_performed(type : ActionType):
	pass
