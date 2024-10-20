extends Node


@onready var parent: CharacterBody2D = get_parent()
# Called when the node enters the scene tree for the first time.
func run_state(delta):
	parent.player_input()
	parent.aim(parent.get_global_mouse_position())
	
func _physics_process(delta: float) -> void:
	var direction = (parent.player_look() * 100) + parent.global_position
	if (parent.player_look() == Vector2.ZERO):
		direction = Vector2(parent.global_position.x+(parent.player_sprite.scale.x * 100),parent.global_position.y-25)
	aim(direction)
	parent.grapple_cast.look_at(direction)


func _flip_player_sprite(val: bool):
	match val:
		true:
			parent.player_sprite.scale.x = -1
		false:
			parent.player_sprite.scale.x = 1

func aim(pos: Vector2):
	if (pos.x < parent.global_position.x):
		_flip_player_sprite(true)
	elif (pos.x > parent.global_position.x):
		_flip_player_sprite(false)
	else:
		pass
	if (pos.x < parent.global_position.x):
		parent.arm.rotation = lerp_angle(parent.arm.rotation, -(parent.aim_pivot.global_position - pos).angle(), (1))
	else:
		parent.arm.rotation = lerp_angle(parent.arm.rotation, (pos - parent.aim_pivot.global_position).angle(), (1))
