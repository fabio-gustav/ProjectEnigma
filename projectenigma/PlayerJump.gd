extends State

class_name PlayerJump




@onready var jumpVelocity:float = ((2.0 * player.jumpHeight) / player.risingJumpTime) * -1.0
@onready var jumpGravity:float = ((-2.0 * player.jumpHeight) / (player.risingJumpTime * player.risingJumpTime)) * -1.0

func Enter():
	player.velocity.y = jumpVelocity
	player.jump_available = false
	
func Exit():
	Transitioned.emit("jumping","falling")

func Update():
	pass

func physicsUpdate(_delta:float):
	player.grapple_cast.look_at(player.get_global_mouse_position())
	var penits = player.grapple_cast.get_collider()
	if penits != null:
		print(penits)
	if penits != null && Input.is_action_just_pressed("grapple"):
		player.grapple_target = penits
		Transitioned.emit("jumping","grappling")
	player.velocity.y += jumpGravity * _delta
	
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("running","dashing")
		
	if player.velocity.y <= 0.0:
		player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
		player.velocity.x  = lerp(player.velocity.x, 0.0, player.airResistance)
	else:
		Exit()
