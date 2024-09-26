extends State

class_name PlayerRunning

func Enter():
	pass

func Exit():
	Transitioned.emit("running","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump"):
		if player.jump_available:
			Transitioned.emit("idle","jumping")
			
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("running","dashing")
		
	if !player.is_on_floor():
		Transitioned.emit("running","falling")
		
		
	player.velocity.x = lerp(player.velocity.x,(get_input()*player.speed),player.acceleration)
	print(player.velocity.x)
	if get_input() == 0.0:
		Exit()



	
