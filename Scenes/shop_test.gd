class_name ShopRoom extends Node

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("move_run")):
		go_to_roaming()

func go_to_roaming() -> void:
	if (Global.currentRoom.scenePath != ""):
		Global.transition_to_scene(Global.currentRoom.scenePath)
