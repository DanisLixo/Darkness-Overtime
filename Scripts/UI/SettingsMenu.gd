extends Control

signal closed
signal opened

var active := false
var selectedIdx := 0

var minimumIdx := -1
var maximumIdx := 0

func open() -> void:
	show()
	
	await get_tree().physics_frame
	opened.emit()
	active = true

func close() -> void:
	hide()
	
	active = false
	selectedIdx = 0
	
	closed.emit()
