extends TextureProgressBar

@onready var health_txt: Label = $HealthText
var tween_value := 100
var real_value := 100
var value_tween : Tween
func _ready() -> void:
	EventBus.player_damaged.connect(change_value.bind())
##Function to change the health value to another one (NOTE: It *sets* the value, it doesn't change it by a specified amount)
func change_value(new_value:int):
	if value_tween and value_tween.is_valid():
		value_tween.kill()
	value_tween = create_tween()
	value_tween.set_trans(Tween.TRANS_EXPO)
	value_tween.set_ease(Tween.EASE_OUT)
	value_tween.tween_method(_change_txt, tween_value, new_value, clampf(abs(new_value - tween_value)/100., 0.2, 1))
	real_value = new_value
	
func _change_txt(new_value:int):
	health_txt.text = "%d/100" %new_value
	size.x += (new_value - tween_value) if tween_value >= 100 and tween_value <= 500 else 0
	value = clamp(new_value, 0, 100)
	tween_value = new_value
