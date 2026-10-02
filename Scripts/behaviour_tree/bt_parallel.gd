class_name BTParallel
extends BehaviorTree

enum Policy {
	REQUIRE_ALL, # Succeeds if ALL children succeed; Fails if ANY child fails
	REQUIRE_ONE  # Succeeds if ANY child succeeds; Fails if ALL children fail
}

@export var success_policy: Policy = Policy.REQUIRE_ALL
@export var failure_policy: Policy = Policy.REQUIRE_ALL

var child_statuses: Dictionary = {}

func _tick(delta: float) -> TickReturn:
	var success_count = 0
	var failure_count = 0
	
	if children.is_empty():
		return TickReturn.SUCCESS

	for child in children:
		var status = child._tick(delta)
		child_statuses[child] = status
		
		if status == TickReturn.SUCCESS:
			success_count += 1
		elif status == TickReturn.FAILURE:
			failure_count += 1

	if success_policy == Policy.REQUIRE_ONE and success_count > 0:
		return TickReturn.SUCCESS
	if success_policy == Policy.REQUIRE_ALL and success_count == children.size():
		return TickReturn.SUCCESS
		
	if failure_policy == Policy.REQUIRE_ONE and failure_count > 0:
		return TickReturn.FAILURE
	if failure_policy == Policy.REQUIRE_ALL and failure_count == children.size():
		return TickReturn.FAILURE

	return TickReturn.RUNNING
