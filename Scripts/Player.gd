class_name Player
extends CharacterBody2D

@export var player_id := 0

@onready var interaction_area: Area2D = $InteractionArea

@onready var state_machine := $StateMachine
@onready var normal_state := $StateMachine/Normal

@onready var sprite_joint: Node2D = $SpriteJoint
@onready var sprite := $SpriteJoint/Sprite

@onready var gun: Node2D = $SpriteJoint/Gun

@onready var effects_handler: StatusEffectsHandler = $StatusEffectsHandler

var input_direction := Vector2.ZERO
var direction := Vector2i.ZERO

var size_mult := 1.0

enum Action {
	X, Y, RUN, SHOOT, JUMP
}

var input_names := [
	["move_left", "move_right"], 
	["move_up", "move_down"], 
	"move_run", "move_shoot", "move_jump"]

var key_press := []
var key_hold := []
var key_release := []

const BASE_PHYSICS := {
	"WALK_MAX_SPEED": 300.0,
	"RUN_MAX_SPEED": 500.0,
	
	"WALK_ACCEL": 35.0,
	"RUN_ACCEL": 45.0,
	
	"JUMP_HEIGHT": 1450.0,
	"JUMP_GRAVITY": 60.0,
	"JUMP_THRESHOLD" : 64.0,
	
	"MOVE_DECEL": 40.0,
	"SKID_DECEL": 75.0
}

var physics := BASE_PHYSICS.duplicate()

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
	"global_position_z": "",
	"velocity": "",
	"velocity_z": "",
	"is_running": "",
	
	"input_direction": "",
	"direction": "",
	
	"shot_delay": "",
	"effects": [""]
}

var global_position_z := 0.0
var velocity_z := 0.0

func _enter_tree() -> void:
	Global.players[player_id] = self

func _process(_delta: float) -> void:
	if (Input.is_physical_key_pressed(KEY_P)):
		physics = BASE_PHYSICS.duplicate()
	
	update_debug()

func _physics_process(_delta: float) -> void:
	scale = Vector2.ONE * size_mult
	
	handle_inputs()

func jump() -> void:
	velocity_z = -physics.JUMP_HEIGHT
	print(str(velocity_z))

var real_z_index := z_index
func z_move(delta: float) -> void:
	if (global_position_z + (velocity_z * delta) >= 0.0):
		velocity_z = 0.0
		global_position_z = 0.0
	
	global_position_z += velocity_z * delta 
	
	set_collision_mask_value(1, is_actually_on_floor())
	set_collision_mask_value(9, !is_actually_on_floor())
	interaction_area.set_collision_layer_value(1, is_actually_on_floor())
	interaction_area.set_collision_layer_value(9, !is_actually_on_floor())
	
	z_index = real_z_index + int(!is_actually_on_floor())
	
	sprite_joint.position.y = global_position_z

func handle_inputs() -> void:
	var input_arr := [key_press, key_hold, key_release]
	var input_calls := [Input.is_action_just_pressed, Input.is_action_pressed, Input.is_action_just_released]

	for i in input_arr.size():
		for j in Action.size():
			if (input_names[j] is Array):
				var negative_input_name = input_names[j][0] + "_%s" % str(player_id)
				var positive_input_name = input_names[j][1] + "_%s" % str(player_id)
				var value = to_input_action(input_calls[i].call(negative_input_name), input_calls[i].call(positive_input_name))
				
				if (input_arr[i].size() <= j):
					input_arr[i].append(value)
				else:
					input_arr[i][j] = value
			else:
				var input_name = input_names[j] + "_%s" % str(player_id)
				var value = input_calls[i].call(input_name)
				
				if (input_arr[i].size() <= j):
					input_arr[i].append(value)
				else:
					input_arr[i][j] = value
	input_direction = Vector2(key_hold[Action.X], key_hold[Action.Y])

func to_input_action(neg_value: Variant, pos_value: Variant, mult := 1.0) -> Variant:
	return int(pos_value) * mult - int(neg_value) * mult

func is_actually_on_floor() -> bool:
	return global_position_z >= 0.0

func is_status_effected() -> bool:
	if (effects_handler == null):
		return false
	return !effects_handler.effects.is_empty()

func has_effect(effect := StatusEffect.Effect.NONE) -> bool:
	if (effects_handler == null):
		return false
	return effects_handler.has_effect(effect)

func update_debug() -> void:
	is_running = key_hold[Player.Action.RUN]
	
	var text := ""
	for key in debug_info:
		if (key.contains("process")):
			debug_info[key] = get_process_delta_time()
		elif (key.contains("physics")):
			debug_info[key] = get_physics_process_delta_time()
		elif (key.contains("shot")):
			debug_info[key] = gun.get(key)
		elif (key.contains("effects")):
			if (effects_handler == null):
				continue
			debug_info[key] = []
			for fx in effects_handler.effects:
				debug_info[key].append_array([StatusEffect.Effect.find_key(fx.effect), fx.time])
		else:
			debug_info[key] = get(key)
		
		text += "%s: %s\n" % [key, str(debug_info[key])]
	
	%DebugLabel.text = text

static func player_action_just_pressed(action_enum: Player.Action, id := 0) -> bool:
	var p: Player = Global.players[id]
	if (p.key_press[action_enum] is bool):
		return p.key_press[action_enum]
	else:
		return p.key_press[action_enum] != 0

static func player_action_pressed(action_enum: Player.Action, id := 0) -> bool:
	var p: Player = Global.players[id]
	if (p.key_hold[action_enum] is bool):
		return p.key_hold[action_enum]
	else:
		return p.key_hold[action_enum] != 0

static func player_action_released(action_enum: Player.Action, id := 0) -> bool:
	var p: Player = Global.players[id]
	if (p.key_release[action_enum] is bool):
		return p.key_release[action_enum]
	else:
		return p.key_release[action_enum] != 0
