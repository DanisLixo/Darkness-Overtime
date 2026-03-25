class_name DialogueText
extends ResourceDE

@export var charResourceName: String
@export var portraitRestAnim: String = "idle"
@export var portraitTalkAnim: String = "talk"
@export_enum("left", "right") var portraitSide = "left" 
@export var exitOtherSide := true

@export_multiline() var text: String
@export_range(0.1, 30.0, 0.1) var textSpeed: float = 20.0

@export var characterTextVolume_db: int
@export var characterTextPitchLimit: Array[float] = [0.90, 1.05]
