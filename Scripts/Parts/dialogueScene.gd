extends Control

const buttonScene := null


@export var dialogue: Array[ResourceDE]
var curDialogueItem := 0
var nextItem := true

var active := false
var players: Array[Player]

var activatorNode: Node

enum ControlState {
	OUTSIDE = -1, INSIDE = 0, 
}

@onready var infoPanel: PanelContainer = $InfoPanel
var panelState := -1

@onready var leftPortrait: Control = $PortraitLeft
var leftSideState := -1
@onready var rightPortrait: Control = $PortraitRight

@onready var leftSprite: AnimatedSprite2D = %LeftSprite
@onready var rightSprite: AnimatedSprite2D = %RightSprite
@onready var dialogueLabel: RichTextLabel = %DialogueText

@onready var dialogueBox: Control = $DialogueBox

var rightSideState := 0

signal dialogueOpen
signal dialogueClose

func _ready() -> void:
	close()
	# Button Container close()
	
	for i in get_tree().get_nodes_in_group("Players"):
		players.append(i)
		
	for i: Player in players:
		i.stateMachine.change_state("Freeze")

func _process(_delta: float) -> void:
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
		
		if (i is DialogueFunction):
			if (i.hideDialogueScene):
				hide()
			else:
				open()
			func_resource(i)
		elif (i is DialogueChoice):
			if (!active):
				open()
			choice_resource(i)
		elif (i is DialogueText):
			if (!active):
				open()
			text_resource(i)
		else:
			printerr("Uso do recurso generico (ResourceDE)! Seu tonto.")
			curDialogueItem += 1
			nextItem = true

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

func choice_resource(res: DialogueChoice) -> void:
	dialogueLabel.text = res.text
	dialogueLabel.visible_characters = -1
	
	var currentPortraitSprite
	if (res.portraitSide == "right"):
		currentPortraitSprite = rightPortrait
	$AnimationPlayer.play("enter" + res.portraitSide.capitalize())
	
	if (res.portraitSpriteFrames != null):
		currentPortraitSprite.get_parent().visible = true
		currentPortraitSprite.sprite_frames = res.portraitSpriteFrames
		currentPortraitSprite.play(res.portraitTalkAnim)
	else:
		currentPortraitSprite.get_parent().visible = false
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

func text_resource(res: DialogueText) -> void:
	var randInt := randi_range(0, res.characterTextSounds.size() - 1)
	# $AudioStreamPlayer.stream = res.characterTextSounds[randInt]
	# $AudioStreamPlayer.volume_db = res.characterTextVolume_db
	
	var currentPortraitSprite
	if (res.portraitSide == "left"):
		currentPortraitSprite = leftSprite
		#if (leftSideState == 0):
			#leftAnim.play("leftPortrait/enter")
		#if (rightSideState == 1 && res.exitOtherSide):
			#rightAnim.play("rightPortrait/exit")
	if (res.portraitSide == "right"):
		currentPortraitSprite = rightSprite
		#if (rightSideState == 0):
			#rightAnim.play("rightPortrait/enter")
		#if (leftSideState == 1 && res.exitOtherSide):
			#leftAnim.play("leftPortrait/exit")
	
	if (res.portraitSpriteFrames == null):
		currentPortraitSprite.get_parent().visible = false
	else:
		currentPortraitSprite.get_parent().visible = true
		currentPortraitSprite.sprite_frames = res.portraitSpriteFrames
		currentPortraitSprite.play(res.portraitTalkAnim)
	
	dialogueLabel.visible_characters = 2
	dialogueLabel.text = "* " + res.text
	
	var textWoutSB = text_without_square_brackets("* " + res.text)
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
				$AudioStreamPlayer.pitch_scale = randf_range(res.characterTextPitchLimit[0], res.characterTextPitchLimit[1])
				$AudioStreamPlayer.play()
			charTimer = 0.0
	
		await get_tree().process_frame
	currentPortraitSprite.play(res.portraitRestAnim)
	
	await get_tree().create_timer(0.5, false).timeout
	while true:
		await get_tree().process_frame
		if (dialogueLabel.visible_characters == totalChars):
			if (Input.is_action_just_pressed("move_action")):
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

func _on_left_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if (anim_name.contains("enter")):
		leftSideState = 1
	elif (anim_name.contains("exit")):
		leftSideState = 0

func _on_right_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if (anim_name.contains("enter")):
		rightSideState = 1
	elif (anim_name.contains("exit")):
		rightSideState = 0
