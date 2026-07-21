class_name Player
extends CharacterBody2D

@export var player_id := 0

@onready var normal_state := $StateMachine/Normal
@onready var state_machine := $StateMachine
@onready var gun := $Gun
@onready var sprite := $SpriteJoint/AnimatedSprite2D

var input_direction := Vector2.ZERO
var direction := Vector2i.ZERO

enum Action {
	X, Y, RUN, SHOOT
}

static var key_press := [false, false, false, false]
static var key_hold := [0.0, 0.0, false, false]
static var key_release := [0, 0, false, false]

var PHYSICS := {
	"WALK_MAX_SPEED": 300.0,
	"RUN_MAX_SPEED": 500.0,
	
	"WALK_ACCEL": 35.0,
	"RUN_ACCEL": 45.0,
	
	"MOVE_DECEL": 40.0,
	"SKID_DECEL": 75.0
}

var physics := PHYSICS

var is_invicible := false
var invincibilty_timer := -1:
	set(value):
		invincibilty_timer = value
		is_invicible = value > 0 

var can_run := true

var can_jump := true
var jump_cooldown := 0

var is_skidding := false
var is_running := false

var debug_info := {
	"process_delta": "",
	"physics_delta": "",
	
	"global_position": "",
	"velocity": "",
	"is_running": "",
	
	"input_direction": "",
	"direction": "",
	
	"shot_delay": "",
}

func _process(delta: float) -> void:
	update_debug()

func update_debug() -> void:
	is_running = Player.key_hold[Player.Action.RUN]
	
	var text := ""
	for key in debug_info:
		if (key.contains("process")):
			debug_info[key] = get_process_delta_time()
		elif (key.contains("physics")):
			debug_info[key] = get_physics_process_delta_time()
		elif (key.contains("shot")):
			debug_info[key] = gun.get(key)
		else:
			debug_info[key] = get(key)
		
		text += "%s: %s\n" % [key, str(debug_info[key])]
	
	%DebugLabel.text = text

func _physics_process(delta: float) -> void:
	handle_inputs()

func handle_inputs() -> void:
	#var input_arr := [Player.key_press, Player.key_hold, Player.key_release]
	#var input_calls := [Input.is_action_just_pressed, [Input.get_axis, Input.is_action_pressed], Input.is_action_just_released]
	#var inputs := ["p%s_left", "p%s_right", "p%s_up"]
	#
	#for key_arr in input_arr.size():
		#for i in Action.size():
			#input_arr[i] = input_calls[i].call()
	
	Player.key_press[Action.X] = to_input_action(Input.is_action_just_pressed("p%s_left" % str(player_id)), Input.is_action_just_pressed("p%s_right" % str(player_id)))
	Player.key_press[Action.Y] = to_input_action(Input.is_action_just_pressed("p%s_up" % str(player_id)), Input.is_action_just_pressed("p%s_down" % str(player_id)))
	Player.key_press[Action.RUN] = Input.is_action_just_pressed("p%s_run" % str(player_id))
	Player.key_press[Action.SHOOT] = Input.is_action_just_pressed("p%s_shoot" % str(player_id))
	
	Player.key_hold[Action.X] = Input.get_axis("p%s_left" % str(player_id), "p%s_right" % str(player_id))
	Player.key_hold[Action.Y] = Input.get_axis("p%s_up" % str(player_id), "p%s_down" % str(player_id))
	Player.key_hold[Action.RUN] = Input.is_action_pressed("p%s_run" % str(player_id))
	Player.key_hold[Action.SHOOT] = Input.is_action_pressed("p%s_shoot" % str(player_id))
	
	Player.key_release[Action.X] = to_input_action(Input.is_action_just_released("p%s_left" % str(player_id)), Input.is_action_just_released("p%s_right" % str(player_id)), 2)
	Player.key_release[Action.Y] = to_input_action(Input.is_action_just_released("p%s_up" % str(player_id)), Input.is_action_just_released("p%s_down" % str(player_id)), 2)
	Player.key_release[Action.RUN] = Input.is_action_just_released("p%s_run" % str(player_id))
	Player.key_release[Action.SHOOT] = Input.is_action_just_released("p%s_shoot" % str(player_id))
	
	input_direction = Vector2(Player.key_hold[Action.X], Player.key_hold[Action.Y])

func to_input_action(neg_value: Variant, pos_value: Variant, mult := 1.0) -> Variant:
	return int(pos_value) * mult - int(neg_value) * mult
