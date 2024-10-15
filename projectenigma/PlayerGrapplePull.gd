extends State

class_name PlayerGrapplePull

var targetPosition

@export var grapplejumpHeight:float = 768
@export var risinggrappleJumpTime:float = 0.4
@onready var jumpVelocity:float = ((2.0 * player.jumpHeight) / player.risingJumpTime) * -1.0
@onready var jumpGravity:float = ((-2.0 * player.jumpHeight) / (player.risingJumpTime * player.risingJumpTime)) * -1.0

func Enter():
	var direction = player.player_look()
	targetPosition = player.grapple_target.global_position
	player.jump_available = false
	player.velocity = Vector2(0,0)
	
func Exit():
	Transitioned.emit("grapplepulling","falling")

func Update():
	pass

func physicsUpdate(_delta:float):
	
	if targetPosition.y < player.global_position.y:
		player.velocity += (player.global_position.direction_to(targetPosition)) * player.grapple_pull_speed
	else:
		Exit()
	
