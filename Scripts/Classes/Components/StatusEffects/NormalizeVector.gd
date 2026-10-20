##A template for StatusEffect subclasses
class_name NormalizeVector
extends StatusEffect

func _start() -> void:
	super()
	pass

func _tick(delta:float) -> void:
	super(delta)
	pass

func apply_static() -> void:
	pass

func apply_dynamic(type:ActionType) -> void:
	if type == ActionType.MOVE:
		var vector = effects_handler.components[&"MovementComponent"].get("input_direction")
		if (vector is Vector2):
			effects_handler.components[&"MovementComponent"].set("input_direction", vector.normalized())
			#if (true && randi_range(0, 99) >= 74):
				#var stop_time := randi_range(0, 99) < 80
				#while stop_time:
					#stop_time = randi_range(0, 99) < 80
					#
					#effects_handler.components[&"InputComponent"].set("input_direction", Vector2i.ZERO) 
					#await parent.get_tree().process_frame 
					#effects_handler.components[&"InputComponent"].set("input_direction", Vector2i.ZERO)
