@tool
class_name TitleScreen extends RoomClass

func _ready() -> void:
	Global.currentMode = Global.GameMode.FREEROAM
	$CanvasLayer/Control/MainList/Start/SelectableLabel.grab_focus()
"res://Assets/Fla's/placeholder.png"
