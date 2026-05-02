extends Node

enum File {ONE, TWO, THREE}
enum PlayState {INMENUS, PLAYING, CUTSCENE}
enum GameMode {FREEROAM, BATTLE, SPECIAL}
var itemMap := {}
const langCodes := ["pt-br", "en"]
var configPath := get_local_dir()

var currentVersion := -1
var isUnrelease := true

var debug := false

var countTime := false
var playtime := 0.0

var currentFile: Global.File = File.ONE
var saveFiles := []
var inventory := [0, 0, 0, 0, 0, 0]
var flags := []

var ambience := "rain"
var currentRoom: RoomClass

var gameDate := [-1, -1]

var currentState: Global.PlayState = PlayState.INMENUS
var currentMode: Global.GameMode = GameMode.SPECIAL
var paused := false

## Sem funcao por agora, somente eh um autoload
@onready var gameHud := $GameHud
@onready var mouse := $Misc/AnimatedSprite2D

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _ready() -> void:
	setup_config()

func _process(delta: float) -> void:
	if (countTime):
		playtime += delta
	handle_mouse()
	
func setup_config() -> void:
	update_item_id_map()
	
	var dirs := ["files"]
	for d in dirs:
		var path := configPath.path_join(d)
		if (!DirAccess.dir_exists_absolute(path)):
			DirAccess.make_dir_recursive_absolute(path)

func update_item_id_map() -> void:
	itemMap.clear()
	
	var path := "res://Resources/ItemIDMap.json"
	var map := FileAccess.open(path, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(map.get_as_text())
	
	itemMap = json.duplicate(true)

func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()

func transition_to_scene(scene_path: StringName = "*.tscn") -> void:
	if (load(scene_path) == null):
		printerr("Cena nao encontrada.")
		return
	
	$GameHud.reset()
	
	$Misc/ColorRect.show()
	$Misc/AnimationPlayer.play("fade_in")
	await $Misc/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene_path)
	$Misc/AnimationPlayer.play_backwards("fade_in")

func add_dialogue(dialogue) -> void:
	currentState = PlayState.CUTSCENE
	
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
