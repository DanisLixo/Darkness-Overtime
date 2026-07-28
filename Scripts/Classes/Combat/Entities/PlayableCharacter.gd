class_name PlayableCharacter extends Node2D

@export var characterInfoResource: CharacterStats
@export var characterId := "Y_character"
@export var characterName := "Y"
@export var abilities := [
	{
		"name": "Scanear",
		"type": CharacterStats.ActionType.ATTACK,
		"cost": 0,
		"costType": "EP",
		"metadata": {
			"damage": 2,
			"use_once": true
		}
	},
	{
		"name": "Curto-Circuito",
		"type": CharacterStats.ActionType.ATTACK,
		"cost": [2, 5],
		"costType": ["EP", "HP"],
		"metadata": {
			"damage": 6
		}
	},
	{
		"name": "Taser",
		"type": CharacterStats.ActionType.ATTACK,
		"cost": 6,
		"costType": "EP",
		"metadata": {
			"damage": 4,
			"effect": ["eletrecute", 0.75]
		}
	},
]

var isLow := false
var characterMaxHP := 24.0
var HP := 24.0

var characterMaxEP := 12.0
var EP := 12.0

var hpBarDirection := 0
var epBarDirection := 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	handle_stats_bars(delta)

func handle_stats_bars(delta: float) -> void:
	%HP.text = "%s/%s" % [int(HP), int(characterMaxHP)]
	%EP.text = "%s/%s" % [int(EP), int(characterMaxEP)]
	
	var barPercHP = snapped(%HPBar.scale.x, 0.01)
	var curPercHP = snapped(HP/characterMaxHP, 0.01)
	
	var barPercEP = snapped(%EPBar.scale.x, 0.01)
	var curPercEP = snapped(EP/characterMaxEP, 0.01)
	
	set_bar_direction("hpBarDirection", barPercHP, curPercHP)
	set_bar_direction("epBarDirection", barPercEP, curPercEP)
	
	if (curPercHP != barPercHP):
		%HPBar.scale.x += delta * hpBarDirection
	if (curPercEP != barPercEP):
		%EPBar.scale.x += delta * epBarDirection
	
	var direction_to_go = sign(curPercHP - barPercHP)
	if (direction_to_go != hpBarDirection):
		hpBarDirection = 0
		%HPBar.scale.x = curPercHP
	
	direction_to_go = sign(curPercEP - barPercEP)
	if (direction_to_go != epBarDirection):
		epBarDirection = 0
		%EPBar.scale.x = curPercEP

func set_bar_direction(valuestr := "", from := 0.0, to := 0.0) -> void:
	var value = get(valuestr)
	var direction_to_go = sign(to - from)
	
	if (value == 0 and direction_to_go != 0):
		set(valuestr, direction_to_go)
		print(get(valuestr))
	elif (direction_to_go != value):
		set(valuestr, 0)
