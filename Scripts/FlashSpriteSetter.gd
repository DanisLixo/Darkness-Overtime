class_name FlashSpriteSetter
extends Node

enum ResourceType {
	SPRITE_FRAMES, TEXTURE, ANIMATION_PLAYER
}

@export var xml_path: String
@export var node_to_affect: CanvasItem
@export var resource_type: ResourceType
@export var property_name := ""

func init() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
func _ready() -> void:
	pass

func _enter_tree() -> void:
	update_resource()

func update_resource() -> void:
	randomize()
	if is_inside_tree() == false or is_queued_for_deletion() or xml_path == "" or node_to_affect == null:
		return
	
	var xml_file := parse_xml_to_dict(xml_path)
	if (xml_file == null):
		push_error("Given XML path doesn't return an actual resource.")
	#var resource := get_resource(xml_file)

func parse_xml_to_dict(path := "") -> Dictionary:
	var dict := {}
	
	var fileParser = XMLParser.new();
	fileParser.open(path);
	
	if (fileParser.read() != OK):
		print("error in %s " % [path]);
		return dict
	
	while fileParser.read() == OK:
		if fileParser.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		var node_name := fileParser.get_node_name()
		var attributes_dict := {}
		for i in fileParser.get_attribute_count():
			var attribute_name := fileParser.get_attribute_name(i)
			var attribute_value := fileParser.get_named_attribute_value_safe(attribute_name)
			attributes_dict[attribute_name] = attribute_value
		
		dict[node_name] = attributes_dict
	
	return dict

func create_res_file(image: Texture, anim, haveLoop, fps):
	var animationSTUFF = SpriteFrames.new();
	animationSTUFF.remove_animation("default");
	
	add_anim(animationSTUFF, image, fps, haveLoop)

func add_anim(animPlayer, image, fps, loop, args = []):
	var fileParser = XMLParser.new();
	fileParser.open("res://%s.xml"%[image]);
	
	if fileParser.read() != OK:
		print("error in %s.xml"%[image]);
		return;
		
	if animPlayer is AnimationPlayer:
		var new_animation = [];
		var data_list = [];
		var new_anim_data = [];
		
		while fileParser.read() == OK:
			var xmlList = {
				"animation": [],
				"x": fileParser.get_named_attribute_value_safe("x").to_int(),
				"y": fileParser.get_named_attribute_value_safe("y").to_int(),
				"width": fileParser.get_named_attribute_value_safe("width").to_int(),
				"height": fileParser.get_named_attribute_value_safe("height").to_int(),
				"frameX": fileParser.get_named_attribute_value_safe("frameX").to_int(),
				"frameY": fileParser.get_named_attribute_value_safe("frameY").to_int(),
				"frameWidth": fileParser.get_named_attribute_value_safe("frameWidth").to_int(),
				"frameHeight": fileParser.get_named_attribute_value_safe("frameHeight").to_int(),
				"rotated": fileParser.get_named_attribute_value_safe("rotated") == "true"
			};
			
			var anim_name = fileParser.get_named_attribute_value_safe("name");
			if fileParser.get_node_type() != XMLParser.NODE_ELEMENT:
				continue;
				
			if fileParser.get_node_name() != "SubTexture":
				continue;
				
			if fileParser.get_named_attribute_value_safe("name") != "":
				var animArray = [];
				for i in fileParser.get_named_attribute_value_safe("name"):
					animArray.append(i);
					
				xmlList["animation"].append(''.join(animArray).substr(0, animArray.size() - 4));
				
				for i in xmlList["animation"]:
					if !new_animation.has(i):
						new_animation.append(i);
						
				var new_anim = anim_name.substr(0, len(anim_name) - 4);
				
				new_anim_data.append_array(xmlList["animation"])
				
				data_list.append({
					new_anim: [
						xmlList["x"],
						xmlList["y"], 
						xmlList["width"], 
						xmlList["height"],
						xmlList["frameX"], 
						xmlList["frameY"], 
						xmlList["frameWidth"],
						xmlList["frameHeight"],
						xmlList["rotated"]
					]
				});
				
		var anim_lib = AnimationLibrary.new();
		var cur_animName = "";
		for i in new_animation.size():
			var new_anim = Animation.new();
			
			var index = new_anim.add_track(Animation.TYPE_VALUE);
			var index_offset = new_anim.add_track(Animation.TYPE_VALUE);
			var rotation_track = new_anim.add_track(Animation.TYPE_VALUE);
			
			cur_animName = new_animation[i];
			
			new_anim.track_set_interpolation_type(index, Animation.INTERPOLATION_NEAREST);
			new_anim.track_set_interpolation_type(index_offset, Animation.INTERPOLATION_NEAREST);
			new_anim.track_set_interpolation_type(rotation_track, Animation.INTERPOLATION_NEAREST);
			
			new_anim.track_set_path(index, "%s:region_rect"%[args[0].get_path_to(args[1])]);
			new_anim.track_set_path(rotation_track, "%s:rotation_degrees"%[args[0].get_path_to(args[1])]);
			new_anim.track_set_path(index_offset, "%s:offset"%[args[0].get_path_to(args[1])]);
			
			new_anim.loop_mode = loop;
			
			var cur_frame = 0;
			var rotated_frame = false;
			for j in range(new_anim_data.size()):
				if data_list[j].has(cur_animName):
					var rotated = data_list[j][cur_animName].size() > 8 && data_list[j][cur_animName][8];
					
					if rotated:
						rotated_frame = true;
						
				for key in data_list[j].keys():
					if key != cur_animName:
						continue;
						
					var region_margin = Rect2(
						Vector2(data_list[j][key][0], data_list[j][key][1]),
						Vector2(data_list[j][key][2], data_list[j][key][3])
					);
					
					var offset_x = 0.0;
					var offset_y = 0.0;
					
					if rotated_frame:
						offset_x = int(data_list[j][key][4]);
						offset_y = int(data_list[j][key][5]);
					else:
						offset_x = int(data_list[j][key][4]) + (int(data_list[j][key][6]) - int(data_list[j][key][2])) / 2.0;
						offset_y = int(data_list[j][key][5]) + (int(data_list[j][key][7]) - int(data_list[j][key][3])) / 2.0;
						
					var offset_margin = Vector2(offset_y, -offset_x) if rotated_frame else -Vector2(offset_x, offset_y);
					
					new_anim.track_insert_key(index, cur_frame * 0.03, region_margin);
					new_anim.track_insert_key(index_offset, cur_frame * 0.03, offset_margin);
					new_anim.track_insert_key(rotation_track, cur_frame * 0.03, 90*%SpinBox2.value if data_list[j][key].size() > 8 && data_list[j][key][8] else 0.0);
					new_anim.length = cur_frame*0.03;
					
					cur_frame += 1;
					
			cur_animName = cur_animName.strip_edges().trim_suffix("/");
			anim_lib.add_animation(cur_animName, new_anim);
			
		animPlayer.add_animation_library("", anim_lib);
		
	if animPlayer is SpriteFrames:
		if animPlayer.has_animation("default"):
			animPlayer.remove_animation("default");
			
		while fileParser.read() == OK:
			var xmlList = {
				"animation": [],
				"x": fileParser.get_named_attribute_value_safe("x").to_int(),
				"y": fileParser.get_named_attribute_value_safe("y").to_int(),
				"width": fileParser.get_named_attribute_value_safe("width").to_int(),
				"height": fileParser.get_named_attribute_value_safe("height").to_int(),
				"frameX": fileParser.get_named_attribute_value_safe("frameX").to_int(),
				"frameY": fileParser.get_named_attribute_value_safe("frameY").to_int(),
				"frameWidth": fileParser.get_named_attribute_value_safe("frameWidth").to_int(),
				"frameHeight": fileParser.get_named_attribute_value_safe("frameHeight").to_int(),
				"rotated": fileParser.get_named_attribute_value_safe("rotated") == "true"
			};
			var frameTexture = AtlasTexture.new();
			frameTexture.atlas = load("res://%s.png"%[image])
			
			if fileParser.get_node_type() != XMLParser.NODE_ELEMENT:
				continue;
				
			if fileParser.get_node_name() != "SubTexture":
				continue;
				
			if fileParser.get_named_attribute_value_safe("name") != '':
				var animArray = [];
				for i in fileParser.get_named_attribute_value_safe("name"):
					animArray.append(i);
					
				xmlList["animation"].append(''.join(animArray).substr(0, animArray.size() - 4));
				
				frameTexture.region = Rect2(
					Vector2(xmlList["x"], xmlList["y"]),
					Vector2(xmlList["width"], xmlList["height"])
				);
				
				frameTexture.margin = Rect2(
					Vector2(-int(xmlList["frameX"]),-int(xmlList["frameY"])),
					Vector2(int(xmlList["frameWidth"]) - frameTexture.region.size.x, int(xmlList["frameHeight"]) - frameTexture.region.size.y)
				);
				
				if frameTexture.margin.size.x < abs(frameTexture.margin.position.x):
					frameTexture.margin.size.x = abs(frameTexture.margin.position.x);
					
				if frameTexture.margin.size.y < abs(frameTexture.margin.position.y):
					frameTexture.margin.size.y = abs(frameTexture.margin.position.y);
					
				var curAnimation = '';
				for j in xmlList["animation"]:
					if j != '':
						curAnimation = j;
						
				if !animPlayer.has_animation(curAnimation):
					animPlayer.add_animation(curAnimation);
					animPlayer.set_animation_loop(curAnimation, loop);
					animPlayer.set_animation_speed(curAnimation, fps);
					
				animPlayer.add_frame(curAnimation, frameTexture)
