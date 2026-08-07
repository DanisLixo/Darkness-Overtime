## Currently not used. Gives the character an step sound by frame and animation.
class_name StepSounds extends Node

@export var sprite_node := get_parent()

@export var sprite_on_step := "walk"
@export var frames_to_play: Array[int]

var stepped := false

signal stepping

func _process(_delta: float) -> void:
	if (sprite_node.animation.contains(sprite_on_step) && sprite_node.frame in frames_to_play):
		if (!stepped):
			AudioManager.play_sfx("step", false, sprite_node.owner.global_position)
		stepped = true
		stepping.emit()
	else:
		stepped = false
