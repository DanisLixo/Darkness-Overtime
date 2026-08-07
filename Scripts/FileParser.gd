class_name FileParser extends Object

enum Mode {JSON, XML}

## Parse the file to a dictionary using the path to the file.
static func parse_to_dict(file_path: String, mode := Mode.JSON) -> Dictionary:
	match mode:
		Mode.JSON:
			return _parse_string(file_path, parse_to_string(file_path))
		Mode.XML:
			return _parse_starling_xml_to_dict(file_path)
		_:
			return {}

static func parse_to_string(file_path: String) -> String:
	# Don't load the file if it doesn't exist.
	if (!FileAccess.file_exists(file_path)):
		printerr("\"%s\" is not a existing file!" % file_path)
		return ""
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if (file == null):
		# This method finds the error for the latest opened file, returning a value from the error enum.
		var file_error := FileAccess.get_open_error()

		Global.log_error("Mod File not opened: \"%s\", an error has occured.\nCODE: %s" % [file_path, error_string(file_error)])
		return ""

	var string := file.get_as_text()
	file.close()
	
	return string

## Save the provided data into a file. If the data is not String, it will be stringified first.
static func save_to_file(data: Variant, saving_path: String) -> Error:
	if (data is not String):
		# We almost always use Dictionaries anyways LOL!
		data = JSON.stringify(data, "\t", false)
	
	var file := FileAccess.open(saving_path, FileAccess.WRITE)
	
	# Don't load the file if you... can't.
	if (file == null):
		var file_error := FileAccess.get_open_error()
		Global.log_error("File couldn't be created: \"%s\", an error has occured.\nCODE: %s" % [saving_path, error_string(file_error)])
		
		return file_error
	
	file.store_string(data)
	file.close()
	
	return OK

static func _parse_starling_xml_to_dict(path := "") -> Dictionary:
	var dict := {}
	
	dict["TextureAtlas"] = {}
	
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
			var attribute_value = fileParser.get_named_attribute_value_safe(attribute_name)
			if (attribute_value.is_valid_int()):
				attribute_value = attribute_value.to_int()
			
			attributes_dict[attribute_name] = attribute_value
		
		node_name = attributes_dict["name"]
		attributes_dict.erase("name")
		
		dict["TextureAtlas"][node_name] = attributes_dict
	
	return dict

## Parse the string to a dictionary, skipping the file reading part.
static func _parse_string(file_path: String, json_str: String) -> Dictionary:
	var json_obj := JSON.new()
	var json_error = json_obj.parse(json_str)
	
	# Parsing from an object returns to us an error code, but keep the data to itself.
	if (json_error == OK):
		return json_obj.data
	else:
		# This error is given if something is wrong with the json, the rest is treated to the script that asked for it.
		Global.log_error("Error parsing JSON file at path \"%s\"! %s at line %s." % [file_path, json_obj.get_error_message(), json_obj.get_error_line()])
		return {}
