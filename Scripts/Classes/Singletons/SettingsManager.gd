extends Node

var SETTINGS_DIR: String = Global.configPath.path_join("settings.cfg")
var file := {
	"video": 
	{
		"mode": 0,
		"vsync": 1,
		"frame_limit": 0,
		"window_size": [1440, 1080]
	}, 
	"audio": 
	{
		"master": 10,
		"music": 10,
		"sfx": 10,
		"ambience": 10,
		"voice": 10,
	},
	"controls": 
	{
		"move_up": ["W", "Up"],
		"move_down": ["S", "Down"],
		"move_left": ["A", "Left"],
		"move_right": ["A", "Right"],
		"move_action": ["Z", "Space"],
		"move_run": ["X", "Shift"],
		"pause": "Escape",
	},
	"game": 
	{
		"lang": "en"
	}
}

func _enter_tree() -> void:
	load_settings()
	apply_settings()
	
	get_window().size_changed.connect(update_saved_window_size)
	
func update_saved_window_size() -> void:
	var windowSize = get_window().size
	file.video.window_size = [windowSize.x, windowSize.y]

func save_settings() -> void:
	var cfgFile := ConfigFile.new()
	var newFile := file.duplicate_deep()
	
	for section in newFile.keys():
		for key in newFile[section].keys():
			cfgFile.set_value(section, key, newFile[section][key])
	
	cfgFile.save(SETTINGS_DIR)
	
func load_settings() -> void:
	if (!FileAccess.file_exists(SETTINGS_DIR)):
		save_settings()
	
	var cfgFile := ConfigFile.new()
	cfgFile.load(SETTINGS_DIR)
	for section in cfgFile.get_sections():
		for key in cfgFile.get_section_keys(section):
			file[section][key] = cfgFile.get_value(section, key)
			
func apply_settings() -> void:
	for i in file.video.keys():
		# $Apply/Video.set_value(i, file.audio[i])
		continue
	for i in file.audio.keys():
		# $Apply/Audio.set_value(i, file.audio[i])
		continue
