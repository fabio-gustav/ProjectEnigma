extends State

class_name PlayerSlide

@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1.0


func Enter():
	player.floor_snap_length = 100.0

func Exit():
	player.floor_snap_length = 10.0
	Transitioned.emit("sliding","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump"):
		if player.jump_available:
			Transitioned.emit("idle","jumping")
		
	if !player.is_on_floor():
		Transitioned.emit("running","falling")
	
	if !Input.is_action_pressed("dash"):
		Transitioned.emit("sliding","idle")
	var floor_angle = player.get_floor_angle()
	if (floor_angle >= 0.12):
		player.velocity.x += (player.get_floor_normal() * fallGravity * _delta).x
	print(floor_angle)
	if abs(player.velocity.x) >= 0.0001:
		player.velocity.x = lerp(player.velocity.x,0.0,player.slide_friction)
	player.apply_floor_snap()
