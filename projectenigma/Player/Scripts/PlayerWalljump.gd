extends State

class_name PlayerWallJump



@export var walljumpHeight:float = 768
@export var risingwallJumpTime:float = 0.4
@onready var jumpVelocity:float = ((2.0 * player.jumpHeight) / player.risingJumpTime) * -1.0
@onready var jumpGravity:float = ((-2.0 * player.jumpHeight) / (player.risingJumpTime * player.risingJumpTime)) * -1.0

func Enter():
	var direction = player.player_look()
	player.velocity = ((-player.get_wall_normal().normalized())+(-player.up_direction)) * jumpVelocity
	player.jump_available = false
	
func Exit():
	Transitioned.emit("jumping","falling")

func Update():
	pass

func physicsUpdate(_delta:float):
	player.velocity.y += jumpGravity * _delta
	if (player.grapple_check() && Input.is_action_just_pressed("grapple")):
		Transitioned.emit("jumping","grappling")
	
	
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("running","dashing")
	if Input.is_action_pressed("jump"):
		if player.velocity.y <= 0.0:
			player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
			player.velocity.x  = lerp(player.velocity.x, 0.0, player.airResistance)
		else: 
			Exit()
	else:
		Exit()
