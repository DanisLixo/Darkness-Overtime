class_name BTCooldown
extends BehaviorTree

@export var cooldown_time : float = 1.

var time_transcurred : float = 0.
var on_cooldown : bool = false

func _tick(delta : float) -> TickReturn:
	if on_cooldown:
		time_transcurred += delta
		if time_transcurred >= cooldown_time:
			time_transcurred = 0
			on_cooldown = false
	if not on_cooldown:
		var ret_val = children[0]._tick(delta)
		if ret_val == TickReturn.SUCCESS:
			on_cooldown = true
			return TickReturn.SUCCESS
		elif ret_val == TickReturn.RUNNING:
			return TickReturn.RUNNING
	return TickReturn.FAILURE
