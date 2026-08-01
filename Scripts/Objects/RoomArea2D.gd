@tool
extends AreaTrigger2D
class_name RoomArea2D

@export_file("*.tscn") var roomToGo: String
@export_range(0, 99) var enterID: int = 0

static var exitID: int = -1

func player_entered(playerArea: Area2D) -> void:
	super(playerArea)
	
	if (playerIn):
		Global.transition_to_scene(roomToGo)
		RoomArea2D.exitID = enterID
