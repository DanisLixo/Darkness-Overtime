##A hitbox component, meant for dealing with collisions for HealthComponent (dealing damage to it)
extends Area2D
class_name HitboxComponent

@export var damage := 10
@export var status_effect : Array[StatusEffectResource]
