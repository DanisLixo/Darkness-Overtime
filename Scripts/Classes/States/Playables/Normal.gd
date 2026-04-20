extends PlayableState

func process(_delta: float) -> void:
	if (Input.is_action_just_pressed("debug_key")):
		player.debugging = true
		player.stateMachine.change_state("NoClip")

## Roda todo frame de fisica, atualiza o movimento e animacao
func physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animations()

## Atualiza a direcao e a velocidade do personagem
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

## Aceleracao de uma direcao sendo usada (uau).
func handle_acceleration(delta: float) -> void:
	var target_accel = player.WALK_ACCEL
	var target_speed = player.WALK_MAX_SPEED
	
	if (player.can_run && player.keyHold[player.INPUT.RUN]):
		target_accel = player.RUN_ACCEL
		target_speed = player.RUN_MAX_SPEED
	
	if (player.inputDirection.x):
		player.velocity.x = move_toward(player.velocity.x, target_speed * player.inputDirection.x, (target_accel / delta) * delta)
	if (player.inputDirection.y):
		player.velocity.y = move_toward(player.velocity.y, target_speed * player.inputDirection.y, (target_accel / delta) * delta)

## Decelaracao de uma direcao nao sendo usada.
func handle_deceleration(delta: float) -> void:
	var target_decel = player.DECEL
	
	if (!player.inputDirection.x):
		player.velocity.x = move_toward(player.velocity.x, 0, (target_decel / delta) * delta)
	if (!player.inputDirection.y):
		player.velocity.y = move_toward(player.velocity.y, 0, (target_decel / delta) * delta)

## Isso deve ficar mais complexo sei la
func handle_animations() -> void:
	var spriteName = get_animation()
	var speed := 1.0
	if (player.velocity):
		speed = abs(player.velocity.length()) / 300
	
	player.play_animation(spriteName, speed)

## Isso deve ficar mais complexo tambem nao sei.
func get_animation() -> String:
	if (player.inputDirection == Vector2.ZERO):
		return "idle"
	else:
		return "walk"
