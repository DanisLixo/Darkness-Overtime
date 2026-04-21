class_name PauseMenu
extends Control

var active := true

@export var options: Array[Control] = []
@onready var cursor := $Selections/Cursor

@export var willPause := false

var selectedIdx := 0 

signal option_1_selected
signal option_2_selected
signal option_3_selected
signal option_4_selected

signal closed
signal opened

func _ready() -> void:
	open()

func _process(delta: float) -> void:
	if (active):
		handle_inputs()
	cursor.global_position.x = options[selectedIdx].global_position.x
	cursor.global_position.y = options[selectedIdx].global_position.y

func handle_inputs() -> void:
	if (Input.is_action_just_pressed("ui_down")):
		selectedIdx += 1
	if (Input.is_action_just_pressed("ui_up")):
		selectedIdx -= 1
	
	selectedIdx = wrapi(selectedIdx, 0, options.size())
	
	if (Input.is_action_just_pressed("ui_accept")):
		option_selected()
	elif (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("pause")):
		close()

func option_selected() -> void:
	emit_signal("option_%s_selected" % [selectedIdx + 1])

func open_settings() -> void:
	active = false
	# Bla Bla
	active = true

func open() -> void:
	if (willPause):
		Global.paused = true
		get_tree().paused = true
		
	show()
	
	await get_tree().physics_frame
	opened.emit()
	active = true

func close() -> void:
	hide()
	
	active = false
	selectedIdx = 0
	
	closed.emit()
	
	Global.paused = false
	get_tree().paused = false
