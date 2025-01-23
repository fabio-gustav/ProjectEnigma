extends State

class_name PlayerActionIdle

func Enter():
	pass

func Exit():
	pass

func Update():
	pass

func physicsUpdate(_delta:float):
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		Transitioned.emit("idle","attacking")
