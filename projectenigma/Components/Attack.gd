class_name Attack

var attack_damage: float
var knockback_force: float
#var attack_position: Vector2

func _init(attack_damage,knockback_force) -> void:
	self.attack_damage = attack_damage
	self.knockback_force = knockback_force
	#self.attack_position = attack_position
