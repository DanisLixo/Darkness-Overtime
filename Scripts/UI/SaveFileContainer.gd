class_name SaveFileContainer extends Button

@export_enum("First", "Second", "Third") var saveFile := 0

var file := {}

var curIdx := 0
var roomName := ""
var roomGroup := "" 
var playtime := ""
var gameDay := -1
var gameWeek := -1

signal deleted_save

func _ready() -> void:
	set_process(false)
	update()

func grab_info() -> void:
	file = SaveManager.load_save(saveFile, curIdx)
	
	roomName = file.room["name"]
	roomGroup = file.room["group"]
	playtime = SaveManager.convert_playtime(file["playtime"]) 
	gameDay = file["date"][0]
	gameWeek = file["date"][1]

func update() -> void:
	grab_info()
	
	%RoomName.text = roomName
	%RoomGroup.text = roomGroup
	%Playtime.text = playtime
	%GameTime.text = "%s / %s" % [str(gameDay), str(gameWeek)]

func pressed() -> void:
	Global.currentFile = saveFile as Global.File
	Global.countTime = true
	
	Global.transition_to_scene(file.room["path"])

func clear_save() -> void:
	SaveManager.clear_save(saveFile)
	deleted_save.emit()
