extends PlayableState

## Movimento Debug.
func physics_process(_delta: float) -> void:
	player.position += player.inputDirection * (10 + (10 * int(player.keyHold[player.INPUT.RUN])))
