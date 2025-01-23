extends Area2D

class_name HitboxComponent

@export var layer = 1
@export var mask = 4
@export var attack_damage = 10
@export var attack_knockback = 5
#var attack_position = get_parent().global_position 

var attack = Attack.new(attack_damage,attack_knockback)

func _init() -> void:
	collision_layer = layer
	collision_mask = mask

func _ready() -> void:
	connect("area_entered",_on_area_entered)


func _on_area_entered(hurtbox: HurtboxComponent) -> void:
	if hurtbox == null:
		return
	if hurtbox.has_method("damage"):
		hurtbox.damage(attack)
