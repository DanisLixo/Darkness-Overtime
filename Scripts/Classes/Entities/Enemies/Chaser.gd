extends BasicEnemy

func _ready() -> void:
	super()
	
	hitbox_component.area_entered.connect(hit_player.bind())

func _physics_process(delta: float) -> void:
	super(delta)
	
	if get_tree().get_node_count_in_group("Players") != 0:
		state_machine.state.target = get_tree().get_first_node_in_group("Players")

func _process(_delta: float) -> void:
	if health_component.current_health <= health_component.max_health / 2.:
		effects_handler.set_default_value(&"MovementStats.walk_max_speed", 500)
	
func hit_player(player:Node2D):
	pass
