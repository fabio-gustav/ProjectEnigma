extends State

class_name PlayerWallSlide

@onready var left_check:RayCast2D = $WallCheckLeft
@onready var right_check:RayCast2D = $WallCheckRight


#@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1.0

func Enter():
	player.velocity = Vector2.ZERO
	#if player.jump_available:
			#player.coyote_timer.start(player.coyoteTime)
func Exit():
	pass

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump") or player.jump_buffer:
		print(player.jump_buffer)
		Transitioned.emit("wallsliding","walljumping")
		
	player.velocity.y += player.wallslide_gravity * _delta
	
	if !(left_check.is_colliding() or right_check.is_colliding()): 
		print(left_check.is_colliding())
		print(right_check.is_colliding())
		Transitioned.emit("wallsliding","falling")
