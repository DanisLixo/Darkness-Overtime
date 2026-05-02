class_name GameHUD
extends CanvasLayer

func _process(delta: float) -> void:
	handle_pause()
	
func handle_pause() -> void:
	if (get_tree().get_first_node_in_group("Players") != null 
	&& Global.currentState == Global.PlayState.PLAYING):
		if (!get_tree().paused && !Global.paused):
			if (Input.is_action_just_pressed("toggle_inventory")):
				open_inventory()
			if (Input.is_action_just_pressed("pause")):
				activate_pause()
				
func activate_pause() -> void:
	match Global.currentMode:
		Global.GameMode.FREEROAM:
			$FreeRoamPauseMenu.open()

func open_inventory() -> void:
	$Inventory.open()

func reset() -> void:
	$Inventory.close()
	$FreeRoamPauseMenu.close()
