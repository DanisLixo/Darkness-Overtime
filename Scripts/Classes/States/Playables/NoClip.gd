extends PlayableState

func enter(_msg = {}) -> void:
	player.direction = Vector2i(0, 1)
	player.play_animation("idle")

func process(_delta: float) -> void:
	if (Input.is_action_just_pressed("debug_key")):
		player.debugging = false
		player.stateMachine.change_state("Normal")

## Movimento Debug.
func physics_process(_delta: float) -> void:
	player.position += player.inputDirection * (10 + (10 * int(player.keyHold[player.INPUT.RUN])))
