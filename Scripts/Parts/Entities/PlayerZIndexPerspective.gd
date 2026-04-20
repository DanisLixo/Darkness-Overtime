class_name PlayerZIndexPerspective
extends Node

var active := true
@onready var z_index: int = owner.z_index

func _process(delta: float) -> void:
	if (active):
		var player = get_tree().get_first_node_in_group("Players")
		if (player != null):
			owner.z_index = (z_index - player.z_index) + int(owner.global_position.y > player.global_position.y)
