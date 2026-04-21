extends Node

var SAVE_DIR: String = Global.configPath.path_join("files/SAVE.sav")
const SAVE_FILE := {
	"room" : "RoomTest",
	"items" : [],
	"flags" : []
}

var currentFile = SAVE_FILE

func load_save() -> Dictionary:
	var path = SAVE_DIR.replace("SAVE", "file" + str(Global.currentFile))
	if (!FileAccess.file_exists(path)):
		write_save()
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	currentFile = json
	file.close()
	return json
	
func write_save() -> void:
	var save = null
	var saveJson := {}
	
	var path := SAVE_DIR.replace("SAVE", "file" + str(Global.currentFile))
	if (FileAccess.file_exists(path)):
		save = FileAccess.open(path, FileAccess.READ)
		saveJson = JSON.parse_string(save.get_as_text())
		save.close()
	else:
		saveJson = SAVE_FILE.duplicate(true)
	
	saveJson["room"] = Global.currentRoom.name
	saveJson["items"] = Global.items
	saveJson["flags"] = Global.flags
	
	write_to_file(saveJson, path)
	
func write_to_file(json := {}, path := "") -> void:
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(json, "\t", false, false))
	file.close()

func apply_save(json := {}) -> void:
	Global.items = json["items"]
	Global.flags = json["flags"]

func clear_save() -> void:
	var save := SAVE_FILE.duplicate(true)
	apply_save(save)
	
	var path = SAVE_DIR.replace("SAVE", "file" + str(Global.currentFile))
	DirAccess.remove_absolute(path)
	write_save()
