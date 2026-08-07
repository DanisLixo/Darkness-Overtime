extends Node2D
@export var bullet_scene : PackedScene = preload("res://Scenes/Bullet.tscn")
@export var shoot_position : Marker2D


var can_shoot := true
var shot_delay := 0.0
# Would this interpret the owner as a Player even if it isn't?
@onready var player : Player = owner

signal gun_shot

func _ready() -> void:
	gun_shot.connect(gun_fired)

func gun_fired() -> void:
	shot_delay = 0.2

func _process(delta: float) -> void:
	if (shot_delay > 0.0):
		shot_delay -= delta

func _physics_process(_delta: float) -> void:
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
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shoot_position.global_position
	
	AudioManager.play_sfx("gun_shot", false, global_position)
	
	var pos := global_position.direction_to(get_global_mouse_position())
	
	bullet.set_mouse_direction(pos)
	
	gun_shot.emit()
