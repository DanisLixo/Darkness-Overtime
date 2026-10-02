extends State

@export var legs_sprite : AnimatedSprite2D
@export var body_sprite : AnimatedSprite2D
@export var health_component : HealthComponent
@export var movement_component : MovementComponent
@export var navigation_component : NavigationComponent
var target : Node2D

var current_animation = &"guard_idle"

func _ready() -> void:
	health_component.changed_health.connect(hit_received)

func process(_delta: float) -> void:
	if target:
		if current_animation == &"guard_idle":
			body_sprite.position = Vector2(-107, -400)
			current_animation = &"guard_alert"
			body_sprite.play(current_animation)
		navigation_component.target = target
		movement_component.move_direction(false, navigation_component.direction)
		if current_animation == &"guard_alert":
			await body_sprite.animation_finished
			body_sprite.position = Vector2(-107, -300)
			current_animation = &"guard_shield-idle"
			body_sprite.play(current_animation)
		legs_sprite.play(&"guard_legs-walk")

func hit_received():
	if current_animation == &"guard_shield-idle":
		current_animation = &"guard_shield-hit"
		body_sprite.play(current_animation)
		await body_sprite.animation_finished
		current_animation = &"guard_shield-idle"
		body_sprite.play(current_animation)
	if health_component.current_health <= health_component.max_health / 2.:
		if current_animation != &"guard_impact_hurt":
			current_animation = &"guard_shield-break"
			body_sprite.play(current_animation)
			await body_sprite.animation_finished
			current_animation = &"guard-impact-hurt"
			body_sprite.play(current_animation)
