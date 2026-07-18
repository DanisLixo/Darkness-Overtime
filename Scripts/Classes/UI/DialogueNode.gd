class_name DialogueNode extends Control

const buttonScene := null

@export var dialogueArray: DialogueArray
var curDialogueItem := 0
var nextItem := true

var activatorNode: Node

@onready var dialogue := dialogueArray.array
@export var soundManager: Node
@export var dialogueLabel: RichTextLabel

signal dialogueOpen
signal dialogueClose

func open() -> void:
	set_process(true)
	show()
	dialogueOpen.emit()

func close(destroy: bool = false) -> void:
	set_process(false)
	hide()
	dialogueClose.emit()
	if (destroy):
		await get_tree().process_frame
		Global.currentState = Global.PlayState.PLAYING

func _process(_delta: float) -> void:
	if (curDialogueItem == dialogue.size()):
		close(false)
		return
	
	if (nextItem):
		nextItem = false
		var i = dialogue[curDialogueItem]
		
		if (i is DialogueText):
			open()
			text_resource(i)
		elif (i is DialogueChoice):
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

var skipTime := 2
func text_resource(res: DialogueText) -> void:
	var characterResource: DialogueCharacter = get_character_resource(res.charResourceName)
	var randInt := randi_range(0, characterResource.characterTextSounds.size() - 1)
	if (characterResource.characterTextSounds.size() != 0):
		soundManager.stream = characterResource.characterTextSounds[randInt]
	soundManager.volume_db = res.characterTextVolume_db
	soundManager.pitch_scale = randf_range(res.characterTextPitchLimit[0], res.characterTextPitchLimit[1])
	
	skipTime = 2
	dialogueLabel.visible_characters = 2
	dialogueLabel.text = "* " + res.text
	
	var textWoutSB = text_without_square_brackets(dialogueLabel.text)
	var totalChars := textWoutSB.length()
	var charTimer: float = 0.0
	
	while dialogueLabel.visible_characters < totalChars:
		if (Input.is_action_just_pressed("move_action") && skipTime <= 0):
			dialogueLabel.visible_characters = totalChars
			break
		
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
		
		skipTime -= 1
		await get_tree().process_frame
	
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

func get_character_resource(resourceName: String = "") -> DialogueCharacter:
	if (resourceName == ""):
		resourceName = "Y_character"
	var path := "res://Resources/Characters/*character/Dialogue.tres"
	path = path.replace("*character", resourceName)
	return load(path)
