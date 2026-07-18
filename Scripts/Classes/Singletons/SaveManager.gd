extends Node

var SAVE_DIR: String = Global.configPath.path_join("files/File[SLOT]")
const SAVE_FILE := {
	"Room" : {
		"Path" : "",
		"Name": "",
	},
	"Group": -1.0,
	"Items" : [],
	"Flags" : [],
	"Date" : [-1, -1],
	"Party": ["Y_character"]
}

var currentFile = SAVE_FILE

func load_save(slotId := 0, saveId := -1) -> Dictionary:
	var path = SAVE_DIR.replace("[SLOT]", str(slotId))
	if (!DirAccess.dir_exists_absolute(path)):
		return {}
	
	if (DirAccess.get_files_at(path).size() == 0):
		return {}
	
	var lastSave := path.path_join(DirAccess.get_files_at(path)[saveId])
	var file = FileAccess.open(lastSave, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	currentFile = json
	return currentFile
	
func write_save(slotId := 0) -> void:
	var saveJson := SAVE_FILE.duplicate(true)
	
	var path = SAVE_DIR.replace("[SLOT]", str(slotId))
	if (!DirAccess.dir_exists_absolute(path)):
		DirAccess.make_dir_recursive_absolute(path)
	
	saveJson["Room"]["Path"] = Global.currentRoom.scenePath
	saveJson["Room"]["Name"] = Global.currentRoom.areaName
	saveJson["Room"]["Group"] = Global.currentRoom.areaGroup
	
	saveJson["Playtime"] = Global.playtime
	saveJson["Items"] = Global.inventory
	saveJson["Flags"] = Global.flags
	saveJson["Date"][0] = Global.gameDate[0]
	saveJson["Date"][1] = Global.gameDate[1]
	
	write_to_file(saveJson, path.path_join(Time.get_datetime_string_from_system() + ".sav"))

func clear_save(slotId := 0) -> void:
	var path = SAVE_DIR.replace("[SLOT]", str(slotId))
	
	for i in DirAccess.get_files_at(path):
		DirAccess.remove_absolute(path.path_join(i))
	
	DirAccess.remove_absolute(path)

func write_to_file(json := {}, path := "") -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(json, "\t", false, false))
	file.close()

func apply_save(json := {}) -> void:
	Global.inventory = json["Items"]
	Global.flags = json["Flags"]
	Global.playtime = json["Group"]
	Global.gameDate[0] = json["Date"][0]
	Global.gameDate[1] = json["Date"][1]
	Global.party = json["Party"]

func convert_playtime(time := 0.0) -> String:
	var string := ""
	var seconds := floori(time)
	var minutes := floori(seconds / 60)
	var hours := floori(minutes / 60)
	
	string = "%s:%s.%s" % [str(hours).pad_zeros(2), str(minutes % 60).pad_zeros(2), str(seconds % 60).pad_zeros(2)]
	
	print(string)
	return string
