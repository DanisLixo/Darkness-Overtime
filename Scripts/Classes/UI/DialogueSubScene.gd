class_name DialogueSubScene extends DialogueNode

var players: Array[Player]

enum ControlState {
	OUTSIDE, INSIDE
}

@onready var infoPanel: PanelContainer = $InfoPanel
var panelState := -1

@onready var leftPortraitControl: Control = $PortraitLeft
@onready var leftSprite: AnimatedSprite2D = %LeftSprite
var leftSideState := ControlState.OUTSIDE
var leftChanging := false
var leftPositions := [Vector2(-1000, 71), Vector2(0, 71)]

@onready var rightPortraitControl: Control = $PortraitRight
@onready var rightSprite: AnimatedSprite2D = %RightSprite
var rightSideState := ControlState.OUTSIDE
var rightChanging := false
var rightPositions := [Vector2(1600, 71), Vector2(1058, 71)]

@onready var dialogueControl: Control = $DialogueBox
var boxState := ControlState.OUTSIDE
var boxChanging := false
var boxPositions := [Vector2(441.5, 1200), [Vector2(192, 742), Vector2(441.5, 742), Vector2(708, 742)]]


func _ready() -> void:
	global_position = Vector2.ZERO
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)
		
	for i: Player in players:
		i.stateMachine.change_state("Freeze")

func _process(_delta: float) -> void:
	handle_control_states()
	
	if (curDialogueItem == dialogue.size()):
		if (players.size() == 0):
			for i in get_tree().get_nodes_in_group("Players"):
				players.append(i)
			return
		for i: Player in players:
			i.stateMachine.change_state("Normal")
		close(true)
		return
	
	if (nextItem):
		nextItem = false
		var i = dialogue[curDialogueItem]
		
		if (i is DialogueText):
			text_resource(i)
		elif (i is DialogueChoice):
			choice_resource(i)
		elif (i is DialogueFunction):
			if (i.hideDialogueScene):
				hide()
			else:
				open()
			func_resource(i)
		else:
			printerr("Uso do recurso generico (ResourceDE)! Seu tonto.")
			curDialogueItem += 1
			nextItem = true

func text_resource(res: DialogueText) -> void:
	control_set_state("boxState", ControlState.INSIDE)
	
	var characterResource: DialogueCharacter = get_character_resource(res.charResourceName)
	var currentPortraitSprite = get(res.portraitSide + "Sprite")
	update_current_speaker(res, characterResource, currentPortraitSprite)
	
	currentPortraitSprite.play(characterResource.animations.idle["name"])
	
	super(res)

func choice_resource(res: DialogueChoice) -> void:
	var characterResource: DialogueCharacter = get_character_resource(res.charResourceName)
	update_current_speaker(res, characterResource, res.portraitSide + "Sprite")
	
	super(res)

func open() -> void:
	show()
	dialogueOpen.emit()

func close(destroy: bool = false) -> void:
	hide()
	dialogueClose.emit()
	if (destroy):
		await get_tree().process_frame
		Global.currentState = Global.PlayState.PLAYING
		queue_free()

func update_current_speaker(resource: ResourceDE, character: DialogueCharacter, sprite: AnimatedSprite2D) -> void:
	if (resource == null): return
	
	control_set_state(resource.portraitSide + "SideState", ControlState.INSIDE)
	if (resource.exitOtherSide):
		if (resource.portraitSide == "left"):
			control_set_state("rightSideState", ControlState.OUTSIDE)
		if (resource.portraitSide == "right"):
			control_set_state("leftSideState", ControlState.OUTSIDE)
	
	if (sprite != null && character.portraitSpriteFrames != null):
		sprite.sprite_frames = character.portraitSpriteFrames
		sprite.play(character.animations.talk["name"])
	if (character.dialogueIcon != null):
		%Icon.texture = character.dialogueIcon

func choice_button_pressed(targetNode: Node, waitSignalName: String) -> void:
	# Node de escolher .close()
	for i in []: # Node de escolher .get_children
		i.queue_free()
	
	# Tocar Efeito Sonoro em AudioStream caso queiramos um som quando selecionado.
	
	if (waitSignalName != ""):
		var signalName = waitSignalName
		if (targetNode.has_signal(signalName)):
			var signalState = { "done": false }
			var callable = func(_args): signalState.done = true
			targetNode.connect(signalName, callable, CONNECT_ONE_SHOT)
			while !signalState.done:
				await get_tree().process_frame
	
	curDialogueItem += 1
	nextItem = true

func get_character_resource(resourceName: String = "") -> DialogueCharacter:
	if (resourceName == ""):
		resourceName = "Y_character"
	var path := "res://Resources/Characters/*character/Dialogue.tres"
	path = path.replace("*character", resourceName)
	return load(path)

func control_set_state(varName: String, newState: ControlState) -> void:
	set(varName, newState)

func handle_control_states() -> void:
	var states := [leftSideState, rightSideState, boxState]
	var sides := [leftPortraitControl, rightPortraitControl, dialogueControl]
	var changing := [leftChanging, rightChanging, boxChanging]
	var positions := [leftPositions, rightPositions, boxPositions]
	
	for i in states.size():
		var state = states[i]
		var side = sides[i]
		var pos = positions[i][state]
		
		if (state == ControlState.INSIDE && side == dialogueControl):
			enter_dialogue(side, changing[i], pos)
			return
		side_change_position(side, changing[i], pos)

func side_change_position(side: Control, changing: bool = false, positionToGo: Vector2 = Vector2.ZERO, changeY := false) -> void:
	if (changing):
		return
	
	side.position.x = positionToGo.x
	if (changeY):
		side.position.y = positionToGo.y

func enter_dialogue(side: Control, changing: bool = false, positions: Array = []) -> void:
	var final_position: Vector2 = positions[1]
	
	if (leftSideState == ControlState.INSIDE && rightSideState == ControlState.OUTSIDE):
		final_position = positions[2]
	if (rightSideState == ControlState.INSIDE && leftSideState == ControlState.OUTSIDE):
		final_position = positions[0]
		
	side_change_position(side, changing, final_position, true)
