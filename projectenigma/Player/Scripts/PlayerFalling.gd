extends State

class_name PlayerFalling




@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1.0

func Enter():
	if player.jump_available:
			player.coyote_timer.start(player.coyoteTime)

func Exit():
	Transitioned.emit("falling","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if player.is_on_wall_only():
			Transitioned.emit("falling","wallsliding")
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("running","dashing")
	if Input.is_action_just_pressed("jump"):
		
		if player.jump_available:
			Transitioned.emit("falling","jumping")
			
		player.jump_buffer = true
		player.get_tree().create_timer(player.jumpBufferTime).timeout.connect(player.on_jump_buffer_timeout)
		
	
	if (player.grapple_check() && Input.is_action_just_pressed("grapple")):
		Transitioned.emit("jumping","grappling")
	player.velocity.y += fallGravity * _delta
	player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
	player.velocity.x  = lerp(player.velocity.x, 0.0, player.airResistance)
	if player.is_on_floor():
		Exit()
