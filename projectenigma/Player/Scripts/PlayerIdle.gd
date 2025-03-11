extends State

class_name PlayerIdle

func Enter():
	pass

func Exit():
	pass

func Update():
	pass

func physicsUpdate(_delta:float):
	if !player.is_on_floor():
		if player.jump_available:
			get_tree().create_timer(player.coyoteTime).timeout.connect(player.coyoteTimeout)
		Transitioned.emit("idle","falling")
		return
		
	else:
		player.player_look()
		player.velocity.x  = lerp(player.velocity.x, 0.0, player.friction)
		player.jump_available = true
		player.coyote_timer.stop()
		
		if player.jump_buffer:
			print("jump buffer jump")
			player.jump_buffer = false
			Transitioned.emit("idle","jumping")
			return
		
		if get_input() != 0.0:
			Transitioned.emit("idle","running")
			return
		
	if Input.is_action_just_pressed("jump"):
		if player.jump_available:
			Transitioned.emit("idle","jumping")
			return
			
	#if Input.is_action_pressed("slide") and abs(player.velocity.x) >= 0.001:
		#Transitioned.emit("running","sliding")
