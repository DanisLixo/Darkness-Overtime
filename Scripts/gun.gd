extends Node2D

const BULLET_SCENE := preload("res://Scenes/Bullet.tscn")

var can_shoot := true
var shot_delay := 0.0

@onready var player: Player = owner

signal gun_shot

func _ready() -> void:
	gun_shot.connect(gun_fired)

func gun_fired() -> void:
	shot_delay = 0.2

func _process(delta: float) -> void:
	if (shot_delay > 0.0):
		shot_delay -= delta

func _physics_process(delta: float) -> void:
	handle_input()
	handle_direction()

func handle_input() -> void:
	if (Player.player_action_pressed(Player.Action.SHOOT, player.player_id)):
		throw_projectile()

func handle_direction() -> void:
	var dirVector = get_global_mouse_position() - global_position
	rotation = dirVector.angle()

func throw_projectile() -> void:
	if (!can_shoot || shot_delay > 0.0): 
		return
	var bullet := BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %Muzzle.global_position
	
	var pos := global_position.direction_to(get_global_mouse_position())
	
	bullet.set_mouse_direction(pos)
	
	gun_shot.emit()
