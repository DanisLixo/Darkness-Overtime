extends PlayableState

var mouse_aim := false

@onready var saved_direction = player.input_direction

func process(_delta: float) -> void:
	if (Input.is_action_just_pressed("debug_key") && Global.debug):
		player.debugging = true
		player.stateMachine.change_state("NoClip")

func physics_process(delta: float) -> void:
	player.size_mult = 1.0
	if (player.is_status_effected()):
		player.effects_handler.apply_effects()
	
	if (player.is_actually_on_floor()):
		on_floor()
	else:
		in_air()
	
	handle_movement(delta)

func on_floor() -> void:
	handle_direction()
	
	if (Player.player_action_just_pressed(Player.Action.JUMP, player.player_id)):
		player.jump()

func in_air() -> void:
	pass

func handle_movement(delta: float) -> void:
	if (player.is_actually_on_floor()):
		handle_ground_movement(delta)
	else:
		handle_air_movement(delta)
	
	player.move_and_slide()
	player.z_move(delta)

func handle_ground_movement(delta: float) -> void:
	ground_acceleration(delta)
	deceleration(delta)

func handle_air_movement(delta: float) -> void:
	deceleration(delta)
	
	var gravity: float = player.physics.JUMP_GRAVITY
	player.velocity_z += (gravity / delta) * delta

func handle_direction() -> void:
	if (!mouse_aim):
		if (player.input_direction):
			player.direction.x = sign(player.input_direction.x) * int(player.input_direction.y == 0)
			player.direction.y = sign(player.input_direction.y)
	
	if (player.input_direction != Vector2.ZERO):
		# if (!player.is_skidding && (player.input_direction.x == -saved_direction.x || player.input_direction.y == - saved_direction.y)):
			# player.is_skidding = true
		saved_direction = player.input_direction

func ground_acceleration(delta: float) -> void:
	if (player.is_skidding):
		return
	
	var target_accel = player.physics.WALK_ACCEL
	var target_speed = player.physics.WALK_MAX_SPEED
	
	if (player.can_run && Player.player_action_pressed(Player.Action.RUN, player.player_id)):
		target_accel = player.physics.RUN_ACCEL
		target_speed = player.physics.RUN_MAX_SPEED
	
	if (player.input_direction.x != 0.0):
		player.velocity.x = move_toward(player.velocity.x, target_speed * player.input_direction.x, (target_accel / delta) * delta)
	if (player.input_direction.y != 0.0):
		player.velocity.y = move_toward(player.velocity.y, target_speed * player.input_direction.y, (target_accel / delta) * delta)

func deceleration(delta: float) -> void:
	var target_decel = player.physics.MOVE_DECEL if !player.is_skidding else player.physics.SKID_DECEL
	
	if (player.input_direction.x == 0.0):
		player.velocity.x = move_toward(player.velocity.x, 0.0, (target_decel / delta) * delta)
	if (player.input_direction.y == 0.0):
		player.velocity.y = move_toward(player.velocity.y, 0.0, (target_decel / delta) * delta)
	
	if (player.velocity == Vector2.ZERO):
		player.is_skidding = false
