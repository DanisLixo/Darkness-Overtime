@tool
class_name TitleScreen extends RoomClass

func _ready() -> void:
	$CanvasLayer/Control/MainList/Start/SelectableLabel.grab_focus()
