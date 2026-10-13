##The root which ticks its first child, should only be used at the start of a [BehaviorTree]
##
@icon("../icons/bt_root.svg")
class_name BTRoot
extends BehaviorTree

##The speed which the root will call [method BehaviorTree._tick]
@export_custom(PROPERTY_HINT_RANGE, "0.5, 20, suffix:per second") var tick_speed : float = 1:
	set(new_val):
		tick_speed = new_val
		
var child : BehaviorTree
var updates_per_second : float
var time : float = 0

func _init() -> void:
	updates_per_second = 1. / tick_speed
	
func _ready() -> void:
	child = get_children()[0]
	
func _physics_process(delta: float) -> void:
	time += delta
	if time >= updates_per_second:
		if not child:
			var status = child._tick(delta)
			print_debug(TickReturn.keys()[status])
		time = 0
