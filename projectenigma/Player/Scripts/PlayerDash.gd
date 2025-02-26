extends State

class_name PlayerDash

@onready var dashVelocity:float = ((2.0 * player.dashDistance) / player.risingJumpTime)

func Enter():
	print("entering dash")
	player.dash_available = false
	player.dash_cool = false
	player.velocity.y = 0
	player.velocity += get_dash_input() * dashVelocity
	Exit()

func Exit():
	get_tree().create_timer(player.dashCooldown).timeout.connect(player.on_dash_cooldown_timer_timeout)
	print("exiting dash")
	Transitioned.emit("dashing","idle")

func Update():
	pass

func physicsUpdate(_delta:float):
	Exit()


func get_dash_input() -> Vector2:
	var input_direction = Input.get_vector("left","right","up","down").normalized()
	return input_direction
