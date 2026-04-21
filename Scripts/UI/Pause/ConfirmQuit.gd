extends Control

var active := false

@export var options: Array[Control] = []

var selectedIdx := 0

func _process(delta: float) -> void:
	if (active):
		handle_inputs()

func handle_inputs() -> void:
	if (Input.is_action_just_pressed("ui_right")):
		selectedIdx += 1
	if (Input.is_action_just_pressed("ui_left")):
		selectedIdx -= 1
	
	selectedIdx = wrapi(selectedIdx, 0, options.size())
	options[selectedIdx].grab_focus()
	
	if (Input.is_action_just_pressed("ui_accept")):
		option_selected()
	elif (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("pause")):
		close()

func option_selected() -> void:
	if (selectedIdx == 0):
		Global.paused = false
		get_tree().paused = false
		
		Global.transition_to_scene("res://Scenes/Parts/VideoPlayer.tscn")
	elif (selectedIdx == 1):
		close()

func open() -> void:
	show()
	owner.active = false
	
	await get_tree().physics_frame
	active = true

func close() -> void:
	hide()
	owner.active = true
	active = false
	selectedIdx = 0
