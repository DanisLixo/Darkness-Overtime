extends PlayableState

var cameraOut := false
var tweening := false

var running := false

func enter(_msg = {}) -> void:
	player.physics = player.COMBAT_PHYSICS

func process(_delta: float) -> void:
	if (player.keyHold[player.INPUT.RUN] && player.inputDirection != Vector2.ZERO):
		if (!cameraOut):
			apply_zoom_to_camera()
	else:
		if (cameraOut):
			reset_zoom()
	
	if (Input.is_action_just_pressed("debug_key")):
		player.debugging = true
		player.stateMachine.change_state("NoClip")

func physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animations()
	
func handle_movement(delta: float) -> void:
	handle_direction()
	handle_acceleration(delta)
	handle_deceleration(delta)
	
	player.move_and_slide()
	
func handle_direction() -> void:
	# A direcao do input e um float e as vezes pode mudar para zero, direcao e usado para os sprites.
	if (player.inputDirection):
		player.direction = sign(player.inputDirection)
	# Nao e necessario usar o X se o y tem sprites de andar tambem.
	if (player.inputDirection.y != 0):
		player.direction.x = 0

func handle_acceleration(delta: float) -> void:
	var target_accel = player.physics.WALK_ACCEL
	var target_speed = player.physics.WALK_MAX_SPEED
	
	if (player.inputDirection != Vector2.ZERO && player.keyHold[player.INPUT.RUN] && !running):
		player.velocity += player.inputDirection * (player.physics.RUN_MAX_SPEED * 1.25)
	
	running = player.can_run && player.keyHold[player.INPUT.RUN] && player.inputDirection != Vector2.ZERO || !player.keyHold[player.INPUT.RUN] && player.inputDirection != Vector2.ZERO
	
	if (player.can_run && player.keyHold[player.INPUT.RUN]):
		target_accel = player.physics.RUN_ACCEL
		target_speed = player.physics.RUN_MAX_SPEED
	
	if (player.inputDirection.x):
		player.velocity.x = move_toward(player.velocity.x, target_speed * player.inputDirection.x, (target_accel / delta) * delta)
	if (player.inputDirection.y):
		player.velocity.y = move_toward(player.velocity.y, target_speed * player.inputDirection.y, (target_accel / delta) * delta)

func apply_zoom_to_camera() -> void:
	if (tweening):
		return
	
	tweening = true
	
	player.cameraHandler.apply_zoom(Vector2(0.9, 0.9), 0.15, Tween.EaseType.EASE_IN_OUT)
	await player.cameraHandler.zoom_tweened
	
	cameraOut = true
	tweening = false

func reset_zoom() -> void:
	if (tweening):
		return
	
	tweening = true
	
	player.cameraHandler.apply_zoom(Vector2.ONE, 0.15)
	await player.cameraHandler.zoom_tweened
	
	cameraOut = false
	tweening = false

func handle_deceleration(delta: float) -> void:
	var target_decel = player.physics.DECEL
	
	if (!player.inputDirection.x):
		player.velocity.x = move_toward(player.velocity.x, 0, (target_decel / delta) * delta)
	if (!player.inputDirection.y):
		player.velocity.y = move_toward(player.velocity.y, 0, (target_decel / delta) * delta)

func handle_animations() -> void:
	var spriteName = get_animation()
	var speed := 1.0
	if (player.velocity):
		speed = abs(player.velocity.length()) / 300
	
	player.play_animation(spriteName, speed)

func get_animation() -> String:
	if (player.inputDirection == Vector2.ZERO):
		return "idle"
	else:
		return "walk"
