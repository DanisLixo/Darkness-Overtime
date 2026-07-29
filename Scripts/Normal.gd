extends PlayableState

var mouse_aim := false

@onready var saved_direction = player.input_direction

func physics_process(delta: float) -> void:
	handle_movement(delta)
	
func handle_movement(delta: float) -> void:
	player.size_mult = 1.0
	if (player.is_status_effected()):
		player.effects_handler.apply_effects()
	
	handle_acceleration(delta)
	handle_deceleration(delta)
	handle_direction()
	
	player.move_and_slide()
	
func handle_direction() -> void:
	if (!mouse_aim):
		if (player.input_direction):
			player.direction.x = sign(player.input_direction.x) * int(player.input_direction.y == 0)
			player.direction.y = sign(player.input_direction.y)
	
	if (player.input_direction != Vector2.ZERO):
		# if (!player.is_skidding && (player.input_direction.x == -saved_direction.x || player.input_direction.y == - saved_direction.y)):
			# player.is_skidding = true
		saved_direction = player.input_direction

func handle_acceleration(delta: float) -> void:
	if (player.is_skidding):
		return
	
	var target_accel = player.physics.WALK_ACCEL
	var target_speed = player.physics.WALK_MAX_SPEED
	
	if (player.can_run && Player.key_hold[Player.Action.RUN]):
		target_accel = player.physics.RUN_ACCEL
		target_speed = player.physics.RUN_MAX_SPEED
	
	if (player.input_direction.x != 0.0):
		player.velocity.x = move_toward(player.velocity.x, target_speed * player.input_direction.x, (target_accel / delta) * delta)
	if (player.input_direction.y != 0.0):
		player.velocity.y = move_toward(player.velocity.y, target_speed * player.input_direction.y, (target_accel / delta) * delta)

func handle_deceleration(delta: float) -> void:
	var target_decel = player.physics.MOVE_DECEL if !player.is_skidding else player.physics.SKID_DECEL
	
	if (player.input_direction.x == 0.0):
		player.velocity.x = move_toward(player.velocity.x, 0.0, (target_decel / delta) * delta)
	if (player.input_direction.y == 0.0):
		player.velocity.y = move_toward(player.velocity.y, 0.0, (target_decel / delta) * delta)
	
	if (player.velocity == Vector2.ZERO):
		player.is_skidding = false
