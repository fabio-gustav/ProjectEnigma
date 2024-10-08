extends State

class_name PlayerWallSlide




#@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1.0

func Enter():
	player.velocity.y = 0
	#if player.jump_available:
			#player.coyote_timer.start(player.coyoteTime)

func Exit():
	Transitioned.emit("wallsliding","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit("falling","walljumping")
		
	player.velocity.y += player.wallslide_gravity * _delta
	if player.is_on_floor():
		Exit()
