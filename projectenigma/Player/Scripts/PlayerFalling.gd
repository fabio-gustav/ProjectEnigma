extends State

class_name PlayerFalling

@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1.0

func Enter():
	if player.jump_available:
		player.coyote_timer.start(player.coyoteTime)

func Exit():
	Transitioned.emit("falling","idle")
	return

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("falling","dashing")
		return
	if Input.is_action_just_pressed("jump"):
		
		if player.jump_available:
			Transitioned.emit("falling","jumping")
			return
			
		player.jump_buffer = true
		player.get_tree().create_timer(player.jumpBufferTime).timeout.connect(player.on_jump_buffer_timeout)
		return
	
	if (player.grapple_check() && Input.is_action_just_pressed("grapple")):
		Transitioned.emit("falling","grappling")
		return
	player.velocity.y += fallGravity * _delta
	player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
	player.velocity.x  = lerp(player.velocity.x, 0.0, player.airResistance)
	if Input.is_action_just_pressed("parry"):
		if player.parry_buffer or player.is_on_floor() or player.is_on_wall():
			Transitioned.emit("falling","walljumping")
			return
		player.parry_buffer = true
		player.get_tree().create_timer(player.parry_buffer_time).timeout.connect(player.on_parry_buffer_timeout)
	
	if player.is_on_floor():
		Exit()
