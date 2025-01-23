extends State

class_name PlayerActionAttack

@export var attack_damage = 10
@export var attack_knockback = 5
#var attack_position = get_parent().global_position 
var attack = Attack.new(attack_damage,attack_knockback)

func Enter():
	pass

func Exit():
	pass

func Update():
	pass

func physicsUpdate(_delta:float):
	pass
