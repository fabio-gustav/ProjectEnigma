extends State

class_name PlayerParry

@onready var jumpGravity:float = ((-2.0 * player.jumpHeight) / (player.risingJumpTime * player.risingJumpTime)) * -1.0


func Enter():
	var direction = player.player_look()
	if player.velocity.length() < (6000-player.velocity.length()):	
		player.velocity = (((-1*direction) * player.velocity.length()) + ((-1*direction) * 6000))
	else:
		player.velocity = ((-1*direction) * player.velocity.length())
	print("Klablamy!")
	player.jump_available = false
	
	
func physicsUpdate(_delta:float):
	player.velocity.y += jumpGravity * _delta
	player.velocity.x = lerp(player.velocity.x,player.velocity.x+(get_input()*player.airspeed),player.acceleration)
	player.velocity.x = lerp(player.velocity.x, 0.0, player.airResistance)
	if (player.grapple_check() && Input.is_action_just_pressed("grapple")):
		Transitioned.emit("jumping","grappling")
		return
	if Input.is_action_just_pressed("parry"):
		if player.parry_buffer or player.is_on_floor() or player.is_on_wall():
			Transitioned.emit("falling","parry")
			return
		player.parry_buffer = true
		player.get_tree().create_timer(player.parry_buffer_time).timeout.connect(player.on_parry_buffer_timeout)
		return
	
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("jumping","dashing")
		return
		
	if player.velocity.y >= 0.0001:
		Exit()
	

func Exit():
	Transitioned.emit("parry","falling")
