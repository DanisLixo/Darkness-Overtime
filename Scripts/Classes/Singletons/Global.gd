extends Node

const langCodes := ["pt-br", "en"]
var configPath := get_local_dir()

var currentVersion := -1
var isUnrelease := true

var debug := false

var saveFiles := []
var currentFile := 0
var inventory := []
var flags := []

var ambience := "rain"
var inCutscene := false
var currentRoom: RoomClass

var paused := false

## Sem funcao por agora, somente eh um autoload
@onready var gameHud := $GameHud
@onready var mouse := $Misc/AnimatedSprite2D

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	handle_mouse()
	
func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()

func transition_to_scene(scene_path: String = "") -> void:
	if (load(scene_path) == null):
		printerr("Cena nao encontrada.")
		return
	
	$Misc/ColorRect.show()
	$Misc/AnimationPlayer.play("fade_in")
	await $Misc/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene_path)
	$Misc/AnimationPlayer.play_backwards("fade_in")

func add_dialogue(dialogue) -> void:
	inCutscene = true
	$CanvasLayer.add_child(dialogue)
	dialogue.open()

func get_local_dir() -> String:
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
	
