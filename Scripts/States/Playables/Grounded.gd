extends PlayableState

var mouse_aim := false

@export var input_component : InputComponent
@export var movement_component : MovementComponent
@onready var saved_direction : Vector2 = input_component.input_direction

func process(_delta: float) -> void:
	if (Input.is_action_just_pressed("debug_key") && Global.debug):
		player.debugging = true
		player.stateMachine.change_state("NoClip")

func physics_process(delta: float) -> void:
	if (player.is_actually_on_floor()):
		on_floor()
	else:
		in_air()
	
	handle_movement(delta)

func on_floor() -> void:
	handle_direction()
	
	if (InputComponent.player_action_just_pressed(InputComponent.Action.JUMP, player.player_id)):
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
	movement_component.move_direction(InputComponent.player_action_pressed(InputComponent.Action.RUN), input_component.input_direction)

func handle_air_movement(delta: float) -> void:
	#movement_component.deceleration(delta, input_component.input_direction)
	
	var gravity: float = player.physics.JUMP_GRAVITY
	player.velocity_z += (gravity / delta) * delta

func handle_direction() -> void:
	if (!mouse_aim):
		if (input_component.input_direction):
			movement_component.direction.x = sign(input_component.input_direction.x) * int(input_component.input_direction.y == 0)
			movement_component.direction.y = sign(input_component.input_direction.y)
	
	if (input_component.input_direction != Vector2.ZERO):
		# if (!player.is_skidding && (player.input_direction.x == -saved_direction.x || player.input_direction.y == - saved_direction.y)):
			# player.is_skidding = true
		saved_direction = input_component.input_direction
