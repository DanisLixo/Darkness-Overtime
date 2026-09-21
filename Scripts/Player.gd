class_name Player
extends CharacterBody2D

@export var player_id : int = 0
@export var interaction_area : Area2D

@export_group("Visuals")
@export var sprite_joint: Node2D
@export var sprite : AnimatedSprite2D

@export_group("Functionality")
@export var movement_component : MovementComponent
@export var input_component : InputComponent
@export var state_machine : StateMachine
@export var gun: Node2D
@export var effects_handler: StatusEffectsHandler
@export var health_component: HealthComponent

var size_mult : float = 1.0

var key_press : Array[Variant] = []
var key_hold : Array[Variant] = []
var key_release : Array[Variant] = []

var is_invicible : bool = false
var invincibilty_timer : int = -1:
	set(value):
		invincibilty_timer = value
		is_invicible = value > 0 

var debug_info : Dictionary[String, Variant] = {
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

var global_position_z : float = 0.0
var velocity_z : float = 0.0

func _enter_tree() -> void:
	Global.players[player_id] = self

func _process(_delta: float) -> void:
	if (movement_component.direction.y == -1):
		sprite.play("Y_idle-backwards")
	else:
		sprite.play("Y_idle")
	
	update_debug()

func _physics_process(_delta: float) -> void:
	input_component.handle_inputs(player_id)

#region Debug Function
func update_debug() -> void:
	
	var text : String = ""
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
				debug_info[key].append_array([fx.effect_id, "%.2f" %fx.time_remaining])
		else:
			debug_info[key] = get(key)
		
		text += "%s: %s\n" % [key, str(debug_info[key])]
	
	%DebugLabel.text = text
#endregion
