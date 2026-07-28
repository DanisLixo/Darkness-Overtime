extends Node

const langCodes := ["pt-br", "en"]

enum File {ONE, TWO, THREE}
enum PlayState {INMENUS, PLAYING, CUTSCENE}
enum GameMode {FREEROAM, BATTLE, SPECIAL}

var currentVersion := -1
var isUnrelease := true

var debug := false

var countTime := false
var playtime := 0.0

var currentFile: Global.File = File.ONE
var saveFiles := []
var flags := []
var party := ["Y_character"]

var ambience := "rain"
var currentRoom: RoomClass

var gameDate := [-1, -1]

var currentState: Global.PlayState = PlayState.INMENUS
var currentMode: Global.GameMode = GameMode.SPECIAL
var paused := false

var configPath := get_local_dir()

## Sem funcao por agora, somente eh um autoload
@onready var gameHud := $GameHud
@onready var mouse := $Mouse/MouseSprite

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _ready() -> void:
	setup_config()

func _process(delta: float) -> void:
	if (countTime):
		playtime += delta
	handle_mouse()
	
func setup_config() -> void:
	ItemHandler.update_item_id_map()
	print(str(ItemHandler.itemMap))
	
	var dirs := ["files"]
	for d in dirs:
		var path := configPath.path_join(d)
		if (!DirAccess.dir_exists_absolute(path)):
			DirAccess.make_dir_recursive_absolute(path)

func handle_mouse() -> void:
	mouse.global_position = get_viewport().get_mouse_position()

func transition_to_scene(scene_path: StringName = "*.tscn") -> void:
	if (load(scene_path) == null):
		printerr("Cena nao encontrada.")
		return
	
	$GameHud.reset()
	toggle_pause()
	
	$Transition.show()
	$Transition/AnimationPlayer.play("fade_in")
	await $Transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene_path)
	
	$Transition/AnimationPlayer.play_backwards("fade_in")
	await $Transition/AnimationPlayer.animation_finished
	$Transition.hide()
	
	toggle_pause()

func add_dialogue(dialogue) -> void:
	currentState = PlayState.CUTSCENE
	
	$DialogueLayer.add_child(dialogue)
	dialogue.open()

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

func toggle_pause(pauseTo: bool = !Global.paused) -> void:
	get_tree().paused = pauseTo
	Global.paused = pauseTo
