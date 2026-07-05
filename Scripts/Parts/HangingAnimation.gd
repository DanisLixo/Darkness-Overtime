extends Node

@onready var parent : Node2D = get_parent()

const GRAVITY := 7500.0
const MAX_VELOCITY := 10000.0

@export var strength := 5.0:
	set(value):
		strength = value
@export var speed := 0.75:
	set(value):
		speed = value

var globalTime := 0.0
var sineValue := 0.0
var entering := true

var limit := -188

var velocity := Vector2.ZERO

func _ready() -> void:
	if (entering && parent != null):
		reset_animation()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_down")):
		jump()
	if (Input.is_action_just_pressed("debug_key")):
		reset_animation()

func _physics_process(delta: float) -> void:
	handle_physics(delta)
	handle_hanging(delta)
	
	move(delta)

var swing := 1
var last_mult := 1.0
func handle_physics(delta: float) -> void:
	if (entering):
		handle_entering_animation()
	
	if (velocity.y <= 25.0):
		if (swing >= 6):
			velocity.y = 0
			entering = false
				
	var cur_mult = [-1.0, 1.0][int(parent.global_position.y < limit)] 
	var target_gravity = GRAVITY * cur_mult
	if (cur_mult != last_mult):
		if (swing == 1):
			velocity.y = 0
		
		swing += 1
		last_mult = cur_mult
	
	handle_velocity(delta, target_gravity)
	
	if (swing >= 4):
		velocity.y /= 2
	if (swing >= 6):
		velocity.y = 0
		parent.global_position.y = limit

func handle_entering_animation() -> void:
	var cur_mult = [-1.0, 1.0][int(parent.global_position.y < limit)] 
	if (cur_mult != last_mult):
		if (swing == 1):
			$"../Sprite".frame = 1
	if (velocity.y <= 25.0):
		if (swing == 3):
			$"../Sprite".play()

func handle_velocity(delta: float, gravity := GRAVITY, decel := 0) -> void:
	velocity.x += (decel * delta) 
	velocity.y += (gravity * delta) 

func handle_hanging(delta: float) -> void:
	globalTime += delta
	sineValue = strength * sin(globalTime * speed)
	
	parent.global_rotation = deg_to_rad(sineValue)

func reset_rotation() -> void:
	if (parent == null): return
	globalTime = 0.0
	parent.global_rotation = 0

func reset_animation() -> void:
	entering = true
	
	
	$"../Sprite".frame = 0
	
	parent.global_position.y = -1249.0
	velocity = Vector2i.ZERO
	
	swing = 1
	last_mult = 1.0
	
	reset_rotation()

func move(delta: float) -> void:
	velocity.y = clamp(velocity.y, -MAX_VELOCITY, MAX_VELOCITY)
	
	parent.global_position += velocity * delta

func jump() -> void:
	velocity.y = 500.0
	swing = 3
