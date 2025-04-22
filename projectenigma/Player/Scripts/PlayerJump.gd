extends State

class_name PlayerJump


@onready var jump_cut = false

@onready var jumpVelocity:float = ((2.0 * player.jumpHeight) / player.risingJumpTime) * -1.0
@onready var jumpGravity:float = ((-2.0 * player.jumpHeight) / (player.risingJumpTime * player.risingJumpTime)) * -1.0

func Enter():
	player.velocity.y = jumpVelocity
	player.jump_available = false
	
func Exit():
	jump_cut = false
	Transitioned.emit("jumping","falling")

func Update():
	pass

func physicsUpdate(_delta:float):
	
	if jump_cut:
		player.velocity.y += 5*jumpGravity * _delta
	else:
		player.velocity.y += jumpGravity * _delta
	player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
	player.velocity.x  = lerp(player.velocity.x, 0.0, player.airResistance)
	if (player.grapple_check() && Input.is_action_just_pressed("grapple")):
		Exit()
		Transitioned.emit("jumping","grappling")
		return
	if player.is_on_wall() and Input.is_action_pressed("slide"):
		Exit()
		Transitioned.emit("jumping","wallsliding")
		return
	
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Exit()
		Transitioned.emit("jumping","dashing")
		return
	
	if Input.is_action_pressed("jump"):
		return
	else:
		jump_cut = true
		
	if player.velocity.y >= -0.0001:
		Exit()
		return
