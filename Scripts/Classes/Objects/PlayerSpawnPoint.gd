extends Node2D
class_name PlayerSpawnpoint

@export_range(0, 99) var pointID := 0

func _ready() -> void:
	run_room_spawn_check()

func run_room_spawn_check() -> void:
	if (pointID == RoomArea2D.exitID):
		set_player_to_point()
		

func set_player_to_point() -> void:
	for p in get_tree().get_nodes_in_group("Players"):
		if (!p.is_node_ready()):
			await p.ready
		p.set_spawnpoint(self)
	RoomArea2D.exitID = -1
