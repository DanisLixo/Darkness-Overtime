class_name Partner extends AnimatedSprite2D

@export var player:Character;
@export var delay = 5;
@export var partner_offset_y = 70;
@export var partner_offset_x = 90;

func _ready() -> void:
	player.z_index = 1
	
func _process(delta: float) -> void:
	#print(player.z_index)
	if player.path_array.size() <= delay:
		return;
		
	if player.path_array[delay] == null:
		return;
		
	var target = player.path_array[delay]["position"];
	var newDir = Vector2(player.path_array[delay]["dir"]);
	
	partner_offset_y = 190 if player.path_array[delay]["dir"].y > 0 else 50;
	
	newDir.x *= partner_offset_x;
	newDir.y *= partner_offset_y;
	
	target -= newDir;
	
	z_index = player.z_index + (1 if target.y > player.position.y else -1);
	global_position = lerp(global_position, target, 40*delta);
	
	#if target["dir"].x > target["dir"].y:
	#	play("back instance 1");
	#else:
	#	play("front instance 1")
