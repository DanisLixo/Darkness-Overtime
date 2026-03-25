extends Control

const buttonScene := null

@export var dialogueArray: DialogueArray
var curDialogueItem := 0
var nextItem := true

var active := false
var players: Array[Player]

var activatorNode: Node

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
@onready var dialogueLabel: RichTextLabel = %DialogueText
var boxState := ControlState.OUTSIDE
var boxChanging := false
var boxPositions := [Vector2(441.5, 1200), [Vector2(192, 862), Vector2(441.5, 862), Vector2(708, 862)]]

@onready var soundManager := $DialogueSounds
@onready var dialogue := dialogueArray.array

signal dialogueOpen
signal dialogueClose

func _ready() -> void:
	global_position = Vector2.ZERO
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)
		
	for i: Player in players:
		i.stateMachine.change_state("Freeze")

func _process(_delta: float) -> void:
	handle_control_states()
	if (!active): return
	
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
			if (!active):
				open()
			text_resource(i)
		elif (i is DialogueChoice):
			if (!active):
				open()
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
	
	var randInt := randi_range(0, characterResource.characterTextSounds.size() - 1)
	if (characterResource.characterTextSounds.size() != 0):
		soundManager.stream = characterResource.characterTextSounds[randInt]
	soundManager.volume_db = res.characterTextVolume_db
	soundManager.pitch_scale = randf_range(res.characterTextPitchLimit[0], res.characterTextPitchLimit[1])
	
	var currentPortrait = get(res.portraitSide + "PortraitControl")
	var currentPortraitSprite = get(res.portraitSide + "Sprite")
	
	update_current_speaker(res, characterResource, currentPortrait, currentPortraitSprite)
	
	dialogueLabel.visible_characters = 2
	dialogueLabel.text = "* " + res.text
	
	var textWoutSB = text_without_square_brackets(dialogueLabel.text)
	var totalChars := textWoutSB.length()
	var charTimer: float = 0.0
	
	while dialogueLabel.visible_characters < totalChars:
		#*if (Input.is_action_just_pressed("move_action")):
			# dialogueLabel.visible_characters = totalChars
			#break
		
		charTimer += get_process_delta_time()
		if (charTimer >= (1.0 / res.textSpeed) or textWoutSB[dialogueLabel.visible_characters] == " "):
			var character: String = textWoutSB[dialogueLabel.visible_characters]
			dialogueLabel.visible_characters += 1
			if (character != " "):
				randInt = randi_range(0, characterResource.characterTextSounds.size() - 1)
				if (characterResource.characterTextSounds.size() != 0):
					soundManager.stream = characterResource.characterTextSounds[randInt]
				soundManager.pitch_scale = randf_range(res.characterTextPitchLimit[0], res.characterTextPitchLimit[1])
				soundManager.play()
			charTimer = 0.0
	
		await get_tree().process_frame
	currentPortraitSprite.play(characterResource.animations.idle["name"])
	
	await get_tree().create_timer(0.5, false).timeout
	while true:
		await get_tree().process_frame
		if (dialogueLabel.visible_characters == totalChars):
			if (Input.is_action_just_pressed("move_action")):
				curDialogueItem += 1
				nextItem = true

func choice_resource(res: DialogueChoice) -> void:
	var characterResource: DialogueCharacter = get_character_resource(res.charResourceName)
	
	dialogueLabel.text = res.text
	dialogueLabel.visible_characters = -1
	
	var currentPortrait = get(res.portraitSide + "PortraitControl")
	var currentPortraitSprite = get(res.portraitSide + "Sprite")
	
	update_current_speaker(res, characterResource, res.portraitSide + "PortraitControl", res.portraitSide + "Sprite")
	
	# TODO: Node de escolher
	
	for item in res.choiceText.size():
		var dialogueButtonNode = buttonScene #.instantiate()
		if (dialogueButtonNode == null): return
		
		var funcResource: DialogueFunction = res.choiceFunctionCall[item]
		if (funcResource != null):
			var targetNode = get_node(funcResource.targetNodePath)
			dialogueButtonNode.connect("pressed",
			Callable(targetNode, funcResource.funcName).bindv(funcResource.funcArgs),
			CONNECT_ONE_SHOT)
			if (funcResource.hideDialogueScene):
				dialogueButtonNode.connect("pressed", hide, CONNECT_ONE_SHOT)
			
			dialogueButtonNode.connect("pressed",
			choice_button_pressed.bind(targetNode, funcResource.waitSignal), CONNECT_ONE_SHOT)
		else:
			dialogueButtonNode.connect("pressed", choice_button_pressed.bind(null, ""), CONNECT_ONE_SHOT)
			
		# Node de escolher add_child(dialogueButtonNode)
	# Node de escolher .get_child(0).grab_focus()

func func_resource(res: DialogueFunction) -> void:
	print(str(res.targetNodePath))
	var targetNode = activatorNode.get_node(res.targetNodePath)
	
	if (targetNode == null):
		printerr("Function Node e nulo! Nada ira acontecer.")
		curDialogueItem += 1
		nextItem = true
		return
	
	if (targetNode.has_method(res.funcName)):
		if (res.funcArgs.size() == 0):
			targetNode.call(res.funcName)
		else:
			targetNode.callv(res.funcName, res.funcArgs)
	else:
		printerr("Function nao existe para esta etapa do dialogo. Nao tem o que executar.")
	
	if (res.waitSignal != ""):
		var signalName = res.waitSignal
		
		if (res.has_signal(signalName)):
			var signalState = { "done": false }
			var callable = func(_args): signalState.done = true
			
			targetNode.connect(signalName, callable, CONNECT_ONE_SHOT)
			while !signalState.done:
				await get_tree().process_frame
	
	curDialogueItem += 1
	nextItem = true

func open() -> void:
	active = true
	show()
	dialogueOpen.emit()

func close(destroy: bool = false) -> void:
	active = false
	hide()
	dialogueClose.emit()
	if (destroy):
		queue_free()

func update_current_speaker(resource: ResourceDE, character: DialogueCharacter, control: Control, sprite: AnimatedSprite2D) -> void:
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

func text_without_square_brackets(text: String) -> String:
	var result := ""
	var insideBracket := false
	
	for i in text:
		if (i == "["):
			insideBracket = true
			continue
		if (i == ']'):
			insideBracket = false
			continue
		if (!insideBracket):
			result += i
			
	return result

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
