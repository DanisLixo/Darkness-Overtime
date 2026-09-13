class_name InputComponent
extends Node

enum Action {
	X, Y, RUN, SHOOT, JUMP
}
var input_names : Array[Variant] = [
	["move_left", "move_right"], 
	["move_up", "move_down"], 
	"move_run", "move_shoot", "move_jump"]
	
var key_press : Array[Variant] = []
var key_hold : Array[Variant] = []
var key_release : Array[Variant] = []

var input_direction : Vector2 = Vector2.ZERO

var effects_handler : StatusEffectsHandler

func handle_inputs(player_id : int) -> void:
	var input_arr : Array[Array] = [key_press, key_hold, key_release]
	var input_calls : Array[Callable] = [Input.is_action_just_pressed, Input.is_action_pressed, Input.is_action_just_released]

	for i in input_arr.size():
		for j in Action.size():
			if (input_names[j] is Array):
				var negative_input_name : String = input_names[j][0] + "_%s" % str(player_id)
				var positive_input_name : String = input_names[j][1] + "_%s" % str(player_id)

				var value : Variant = to_input_action(input_calls[i].call(negative_input_name), input_calls[i].call(positive_input_name))
				
				if (input_arr[i].size() <= j):
					input_arr[i].append(value)
				else:
					input_arr[i][j] = value
			else:
				var input_name : String = input_names[j] + "_%s" % str(player_id)
				var value : bool = input_calls[i].call(input_name)
				
				if (input_arr[i].size() <= j):
					input_arr[i].append(value)
				else:
					input_arr[i][j] = value
	input_direction = Vector2(key_hold[Action.X], key_hold[Action.Y])


func to_input_action(neg_value: Variant, pos_value: Variant, mult := 1.0) -> Variant:
	return (int(pos_value) - int(neg_value)) * mult
	
static func player_action_just_pressed(action_enum: Player.Action, id := 0) -> bool:
	var player: Player = Global.players[id]
	if (player.key_press[action_enum] is bool):
		return player.key_press[action_enum]
	else:
		return player.key_press[action_enum] != 0

static func player_action_pressed(action_enum: Player.Action, id := 0) -> bool:
	var player: Player = Global.players[id]
	if (player.key_hold[action_enum] is bool):
		return player.key_hold[action_enum]
	else:
		return player.key_hold[action_enum] != 0

static func player_action_released(action_enum: Player.Action, id := 0) -> bool:
	var player: Player = Global.players[id]
	if (player.key_release[action_enum] is bool):
		return player.key_release[action_enum]
	else:
		return player.key_release[action_enum] != 0
