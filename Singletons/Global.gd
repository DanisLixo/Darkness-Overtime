extends Node

@onready var mouse := $Mouse/MouseSprite

var current_room: Room

var players: Array[Player] = [null]

var currentVersion := -1
var isUnrelease := true
var debug := true

var configPath := get_local_dir()
func get_local_dir() -> String:
	if (isUnrelease):
		return "user://"
	
	var exePath := OS.get_executable_path()
	var exeDir := exePath.get_base_dir()
	
	var test = FileAccess.open(exeDir.path_join("test.txt"), FileAccess.WRITE)
	
	if (test):
		test.close()
		var dir := DirAccess.open(exeDir)
		if (dir):
			dir.remove(exeDir.path_join("test.txt").get_file())
		var localDir := exeDir.path_join("save")
		if (!DirAccess.dir_exists_absolute(localDir)):
			DirAccess.make_dir_recursive_absolute(localDir)
		return localDir
	else:
		push_warning("Couldn't create save folder, current exe directory is not writeable. Check Appdata/Roaming")
		
	return "user://"

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	handle_mouse()
	
func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()
