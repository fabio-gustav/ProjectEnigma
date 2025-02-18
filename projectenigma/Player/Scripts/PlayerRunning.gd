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
		
	if !player.is_on_floor():
		Transitioned.emit("running","falling")
	
	if Input.is_action_pressed("dash") and abs(player.velocity.x) >= 0.01:
		Transitioned.emit("running","sliding")
		
	player.velocity.x = lerp(player.velocity.x,(get_input()*player.speed),player.acceleration)
	#print(player.velocity.x)
	if get_input() == 0.0:
		Exit()



	
