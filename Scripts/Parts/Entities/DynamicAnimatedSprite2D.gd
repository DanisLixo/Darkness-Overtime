@tool
class_name DynamicAnimatedSprite2D
extends AnimatedSprite2D

var characterName := ""
var direction := Character.Direction.FRONT
var data: ResourceCS

func _process(_delta: float) -> void:
	if (Engine.is_editor_hint()):
		if (characterName != owner.characterName):
			update_sprites()
		if (direction != owner.initialDirection):
			direction = owner.initialDirection
			change_to_idle()

func get_char_spritedata() -> ResourceCS:
	var path := "res://Resources/Characters/%s/Sprites.tres" % characterName
	var spriteFr = load(path)
	return spriteFr

func update_sprites() -> void:
	characterName = owner.characterName
	data = get_char_spritedata()
	sprite_frames = data.sprite_frames
	
func change_to_idle() -> void:
	play("idle_" + get_animation_direction())
	get_animation_offset(animation)

func get_animation_direction() -> String:
	var directionSprName := "front"
	
	match (direction):
		Character.Direction.BACK:
			directionSprName = "back"
		Character.Direction.LEFT:
			directionSprName = "left"
			if (!owner.asymetricalSprites):
				directionSprName = "side"
		Character.Direction.RIGHT:
			directionSprName = "right"
			if (!owner.asymetricalSprites):
				directionSprName = "side"
	
	return directionSprName

func get_animation_offset(anim: String) -> void:
	if (!sprite_frames.has_animation(anim)):
		return
	var idx := sprite_frames.get_animation_names().find(anim)
	if (anim.contains("walk") && data.loop_offsets):
		var newAnim: String = "idle_" + owner.get_animation_direction()
		idx = sprite_frames.get_animation_names().find(newAnim)
	offset = data.global_offset + data.offsets[idx]
