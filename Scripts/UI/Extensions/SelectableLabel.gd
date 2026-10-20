extends Label

signal pressed

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("mb_left")):
		pressed.emit()

func toggle_process(toggled_on := false) -> void:
	set_process(toggled_on)
