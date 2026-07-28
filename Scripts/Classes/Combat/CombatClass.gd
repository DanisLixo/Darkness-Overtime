@tool
class_name CombatRoomClass extends RoomClass

@onready var hud = Global.gameHud.get_node("Combat")

func _ready() -> void:
	Global.currentMode = Global.GameMode.BATTLE
