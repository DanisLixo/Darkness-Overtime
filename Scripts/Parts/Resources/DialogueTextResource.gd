class_name DialogueText
extends ResourceDE

@export var characterName: String
@export var portraitName: String
@export var portraitSpriteFrames: SpriteFrames
@export var portraitRestAnim: String
@export var portraitTalkAnim: String
@export_enum("left", "right") var portraitSide = "left" 
@export var exitOtherSide := true

@export_multiline() var text: String
@export_range(0.1, 30.0, 0.1) var textSpeed: float = 20.0

@export var characterTextSounds: Array[AudioStream]
@export var characterTextVolume_db: int
@export var characterTextPitchLimit: Array[float] = [0.90, 1.05]
