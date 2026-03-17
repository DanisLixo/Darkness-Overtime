class_name StepSounds extends Node

@onready var parent := get_parent()

@export var sprite := "walk"
@export var framesToPlay: Array[int]
@export var prefix: String = ""

var stepped := false

signal stepping

func _process(_delta: float) -> void:
	if (parent.sprite.animation.contains(sprite) && parent.sprite.frame in framesToPlay):
		if (!stepped):
			AudioManager.play_sfx(Global.ambience + "_step" + prefix, false, parent.global_position)
		stepped = true
		stepping.emit()
	else:
		stepped = false
