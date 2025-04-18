extends State

class_name PlayerRunning


func Enter():
	legs.play("Running")
	arm.play("Running")

func Exit():
	legs.stop()
	arm.stop()
	Transitioned.emit("running","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump"):
		if player.jump_available:
			legs.stop()
			arm.stop()
			Transitioned.emit("idle","jumping")
			return
		
	if !player.is_on_floor():
		legs.stop()
		arm.stop()
		Transitioned.emit("running","falling")
		return
	
	if Input.is_action_pressed("slide") and abs(player.velocity.x) >= 0.01:
		legs.stop()
		arm.stop()
		Transitioned.emit("running","sliding")
		return
		
	player.velocity.x = lerp(player.velocity.x,(get_input()*player.speed),player.acceleration)
	#print(player.velocity.x)
	if get_input() == 0.0:
		Exit()



	
