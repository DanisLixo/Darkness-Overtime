extends Camera2D

const COUNT = 3;
const CAM_SPEED = 120;

func _process(delta: float) -> void:
	var mouse = get_viewport().get_mouse_position()
	var screen_width = get_viewport().get_visible_rect().size.x
	var speed = 0;
	
	for i in range(COUNT):
		var hitBoxes = 100*(i+1);
		
		if mouse.x <= hitBoxes:
			speed -= CAM_SPEED*delta;
			
		if mouse.x >= screen_width - hitBoxes:
			speed += CAM_SPEED*delta;
			
	if (position.x <= 0):
		return;
		
	if (position.x >= screen_width):
		return;
		
	position.x = speed;
	
