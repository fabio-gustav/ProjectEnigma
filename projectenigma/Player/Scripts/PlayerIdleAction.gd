extends State

func enter():
	pass
	
func exit():
	pass
	
func update(_delta:float):
	pass
	
func physicsUpdate(_delta:float):
	
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit("Idle","Attacking")
		return
