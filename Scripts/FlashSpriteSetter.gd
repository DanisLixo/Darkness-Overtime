## Gives the character it's sprites by compiling the Flash exported sprites 
## into a usable sprite node or AnimationPlayer (Not implemented).
class_name FlashSpriteSetter
extends Node

enum ResourceType {
	SPRITE_FRAMES, TEXTURE, ANIMATION_PLAYER
}

@export_file_path("*.json") var json_path: String:
	set(value):
		json_path = value
		update_resource()
@export var node_to_affect: CanvasItem
@export var mode: ResourceType
@export var property_name := ""

var resource_json := {}

func init() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

func _enter_tree() -> void:
	update_resource()

func update_resource() -> void:
	randomize()
	if is_inside_tree() == false or is_queued_for_deletion() or json_path == "" or node_to_affect == null:
		return
	
	var json := load(json_path)
	if (json == null):
		push_error("Given JSON info path doesn't return an actual resource.")
		return
	var resource = get_resource(json)
	
	node_to_affect.set(property_name, resource)
	if node_to_affect is AnimatedSprite2D:
		node_to_affect.play()

func get_resource(json_file: JSON) -> Object:
	var resource: Resource
	var resource_path = json_file.resource_path
	
	resource_json = FileParser.parse_to_dict(resource_path, FileParser.Mode.JSON)
	
	var resource_image_path: String = resource_path.replace(resource_path.get_file(), resource_json["Source"]["Image"])
	var anim_file_path: String = resource_path.replace(resource_path.get_file(), resource_json["Source"]["AnimationFile"])
	
	match mode:
		ResourceType.SPRITE_FRAMES:
			var animation_json = FileParser.parse_to_dict(anim_file_path, FileParser.Mode.XML)
			resource = load_image_from_path(resource_image_path)
			
			if animation_json != {}:
				resource = create_sprite_frames_from_image(resource, animation_json)
			else:
				var sprite_frames = SpriteFrames.new()
				sprite_frames.add_frame("default", resource)
				resource = sprite_frames
		## TODO: TEXTURE (maybe not) and ANIMATION_PLAYER (Atlas Sheets) modes.
		
	return resource

func load_image_from_path(path := "") -> Texture2D:
	if path.contains("res://"):
		if path.contains("NULL"):
			return null
		return load(path)
	var image = Image.new()
	image.load(path)
	return ImageTexture.create_from_image(image)

func create_sprite_frames_from_image(image: Resource, animation_json := {}) -> SpriteFrames:
	var sprite_frames = SpriteFrames.new()
	sprite_frames.remove_animation("default")
	
	# It first converts to a more organised JSON file so it can actually use it.
	if (animation_json.has("TextureAtlas")):
		animation_json = xml_translate_nodes(animation_json["TextureAtlas"])
	
	for anim_name in animation_json:
		sprite_frames.add_animation(anim_name)
		
		sprite_frames.set_animation_loop(anim_name, animation_json[anim_name].get("loop", false))
		if animation_json[anim_name].has("loop_offset") and node_to_affect is AnimatedSprite2D:
			node_to_affect.animation_looped.connect(on_animation_looped.bind(anim_name, animation_json[anim_name].get("loop_offset", 0)))
		sprite_frames.set_animation_speed(anim_name, animation_json[anim_name].get("framerate", 24))
		
		if (animation_json[anim_name].has("frames")):
			for frame in animation_json[anim_name]["frames"]:
				frame = animation_json[anim_name]["frames"][frame]
				var frame_texture = AtlasTexture.new()
				frame_texture.atlas = image
				
				frame_texture.region = Rect2(
					Vector2(frame["x"], frame["y"]), Vector2(frame["width"], frame["height"]));
				
				var frame_x = frame.get("frameX", 0.0)
				var frame_y = frame.get("frameY", 0.0)
				var frame_w = frame.get("frameWidth", 0.0)
				var frame_h = frame.get("frameHeight", 0.0)
				
				# Shoutouts to BigB0ss!
				
				frame_texture.margin = Rect2(
					Vector2(-frame_x, -frame_y), 
					Vector2(frame_w - frame_texture.region.size.x, frame_h - frame_texture.region.size.y));
				
				frame_texture.margin.size.x = abs(frame_texture.margin.position.x);
				frame_texture.margin.size.y = abs(frame_texture.margin.position.y);
				
				frame_texture.filter_clip = true
				sprite_frames.add_frame(anim_name, frame_texture)
				
	return sprite_frames

func on_animation_looped(anim_name := "", loop_offset := 0) -> void:
	var sprite: AnimatedSprite2D = node_to_affect
	if sprite.animation == anim_name:
		sprite.set_frame_and_progress(loop_offset, 0)

func xml_translate_nodes(animation_json := {}) -> Dictionary:
	var animations := {}
	
	# I'd get crazy.
	animation_json.sort()
	
	var current_animation := ""
	
	for animation_node in animation_json:
		# Awesome way of finding the first animation.
		if (animation_node.contains("0000")):
			current_animation = animation_node.replace("0000", "")
			animations[current_animation] = {
				"frames": {},
				"loop": resource_json["AnimationInfo"][current_animation]["loop"],
				"loop-offset": resource_json["AnimationInfo"][current_animation]["loop-offset"],
				"framerate": resource_json["AnimationInfo"][current_animation]["framerate"]
			}
		
		var animation_frame: String = animation_node.replace(current_animation, "")
		animations[current_animation]["frames"][animation_frame] = animation_json[animation_node]
	
	return animations
