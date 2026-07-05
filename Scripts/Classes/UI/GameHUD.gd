class_name GameHUD
extends CanvasLayer

const portraitsPositions := [
	[Vector2(247, 70), 0.8],
	[Vector2(82, 73), 0.6],
	[Vector2(-35, 73), 0.4],
	[Vector2(-114, 73), 0.2]
]

func _process(delta: float) -> void:
	if (Global.currentMode == Global.GameMode.BATTLE):
		handle_combat_hud()
	handle_pause()
	
func handle_pause() -> void:
	if (get_tree().get_first_node_in_group("Players") != null 
	&& Global.currentState == Global.PlayState.PLAYING):
		if (!Global.paused):
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
	$Combat.hide()
	$Inventory.close()
	$FreeRoamPauseMenu.close()

func handle_combat_hud() -> void:
	if (Global.currentMode != Global.GameMode.BATTLE):
		$Combat.hide()
		return
