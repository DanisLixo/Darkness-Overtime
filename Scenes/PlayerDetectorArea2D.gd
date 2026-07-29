class_name PlayerDetectorArea2D
extends Area2D

signal player_entered(player: Player)
signal player_exited(player: Player)

func _ready() -> void:
	area_entered.connect(_player_entered)
	area_exited.connect(_player_exited)
	
func _player_entered(area: Area2D) -> void:
	if (area.owner is Player):
		player_entered.emit(area.owner)

func _player_exited(area: Area2D) -> void:
	if (area.owner is Player):
		player_exited.emit(area.owner)
