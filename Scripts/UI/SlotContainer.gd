class_name SaveSlotContainer extends PanelContainer

@export_enum("First", "Second", "Third") var saveFile := 0
var hasFile := true
var play := false

var file := {}

var roomName := ""
var roomGroup := "" 
var playtime := ""
var gameDay := -1
var gameWeek := -1

func _ready() -> void:
	set_process(false)
	update()

func grab_info() -> void:
	file = SaveManager.load_save(saveFile)
	
	if (file.is_empty()):
		hasFile = false
		return
	
	hasFile = true
	roomName = file.room["name"]
	roomGroup = file.room["group"]
	playtime = SaveManager.convert_playtime(file["playtime"]) 
	gameDay = file["date"][0]
	gameWeek = file["date"][1]

func update() -> void:
	grab_info()
	
	%File.text = %File.text.replace("{NUMBER}", str(saveFile + 1))
	%NewGame.visible = !hasFile
	%Continue.visible = hasFile
	
	if (hasFile):
		%SaveList.slotId = saveFile
		
		%RoomName.text = roomName
		%RoomGroup.text = roomGroup
		%Playtime.text = playtime
		%GameTime.text = "%s / %s" % [str(gameDay), str(gameWeek)]

func pressed() -> void:
	Global.currentFile = saveFile as Global.File
	Global.countTime = true
	
	if (hasFile):
		Global.transition_to_scene(file.room["path"])
	if (!hasFile):
		Global.transition_to_scene("res://Scenes/Parts/VideoPlayer.tscn")

func clear_save() -> void:
	SaveManager.clear_save(saveFile)
	
	update()
