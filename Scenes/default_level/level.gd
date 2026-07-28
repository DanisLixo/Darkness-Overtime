extends Node2D

@export var level_size = Vector2(5,5);
@export var start = Vector2i(1,4);

var rooms = [];

func _ready() -> void:
	for i in level_size.x:
		rooms.append([]);
		for j in level_size.y:
			var rect = ColorRect.new();
			rect.modulate = Color.RED;
			rect.size = Vector2(32, 32);
			rect.position = Vector2(i*rect.size.x, j*rect.size.y);
			rect.set_meta("occupy", false);
			add_child(rect);
			
			rooms[i].append(rect);
			
	add_entrance(start.x, start.y);
	
	var current = start;
	for i in range(15):
		current = reload_path(current);
		
func add_entrance(value_x, value_y, random = false):
	if random:
		value_x = randi_range(0, level_size.x-1);
		value_y = randi_range(0, level_size.y-1);
		
	if (value_x >= 0 && value_x < level_size.x) && (value_y >= 0 && value_y < level_size.y):
		rooms[value_x][value_y].modulate = Color.YELLOW;
		rooms[value_x][value_y].set_meta("occupy", true);
		
func reload_path(current:Vector2i):
	var dirs = [
		Vector2i.UP,
		Vector2i.RIGHT,
		Vector2i.DOWN,
		Vector2i.LEFT
	];
	
	var new_directions = [];
	while new_directions.size() < 4:
		var newDir = dirs[randi_range(0,3)];
		if new_directions.has(newDir):
			continue;
			
		new_directions.append(newDir);
		
	print(new_directions)
	for dir in new_directions:
		var next = current + dir;
		if (next.x >= 0 && next.x < level_size.x) && (next.y >= 0 && next.y < level_size.y) && !rooms[next.x][next.y].get_meta("occupy"):
			rooms[next.x][next.y].modulate = Color.GREEN;
			rooms[next.x][next.y].set_meta("occupy", true);
			return next;
			
	return current;
