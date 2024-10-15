extends State

class_name PlayerSlide


func Enter():
	pass

func Exit():
	Transitioned.emit("sliding","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("jump"):
		if player.jump_available:
			Transitioned.emit("idle","jumping")
		
	if !player.is_on_floor():
		Transitioned.emit("running","falling")
	
	if !Input.is_action_pressed("dash"):
		Transitioned.emit("sliding","idle")
		
	player.velocity.x = lerp(player.velocity.x,0.0,player.slide_friction)
	print(player.velocity.x)
