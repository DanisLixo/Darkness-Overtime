extends VBoxContainer
 
const SAVE_FILE_CONTAINER := preload("res://Scenes/Parts/FileSaveContainer.tscn")

var containers := []

var slotId := 0

func open() -> void:
	%SaveInfo.hide()
	show()
	
	refresh()

func close() -> void:
	hide()
	%SaveInfo.show()

func refresh() -> void:
	for i in get_children():
		if i is SaveFileContainer:
			i.queue_free()
	containers.clear()
	get_files()

func get_files() -> void:
	var path = SaveManager.SAVE_DIR.replace("[SLOT]", str(slotId))
	
	var idx := 0
	for i in DirAccess.get_files_at(path):
		if i.contains(".sav") == false:
			continue
		var container = SAVE_FILE_CONTAINER.instantiate()
		container.curIdx = idx
		container.deleted_save.connect(refresh)
		
		containers.append(container)
		add_child(container)
		
		idx += 1
