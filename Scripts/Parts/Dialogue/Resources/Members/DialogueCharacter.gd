class_name DialogueCharacter extends ResourceDE

@export var characterName: String
@export var portraitSpriteFrames: SpriteFrames
@export var animations := {
	"idle" : {
		"name": "idle",
		"offset": Vector2.ZERO
	},
	"talk" : {
		"name": "talk",
		"offset": Vector2.ZERO
	}
}
@export var characterTextSounds: Array[AudioStream]
@export var dialogueIcon: Texture2D = load("res://Assets/Sprites/Entities/Characters/Placeholder/icon.png")
