extends State

class_name PlayerGrapple

@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1

var target:StaticBody2D
var targetPosition:Vector2
var ropeLength:float
var stop

func Enter():
	targetPosition = player.grapple_target.global_position
	ropeLength = player.global_position.distance_to(targetPosition)


func Exit():
	player.velocity = player.global_position.direction_to(targetPosition) * 1024
	
	Transitioned.emit("grappling","falling")
	

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("grapple"):
		stop = true
		Exit()
	player.velocity.y += fallGravity * _delta
	swing(_delta)
	player.velocity *= 0.99
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Transitioned.emit("dashing","dashing")
	



func endGrapple():
	player.playerGrappled = false
	
	
func swing(_delta):
	var radius = player.global_position - targetPosition
	if player.velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(player.velocity) / (radius.length()*player.velocity.length()))
	var radial_velocity = cos(angle) * player.velocity.length()
	#var radial_velocity = fallGravity
	#var radial_velocity = player.global_position.dot(-targetPosition) * radius.normalized()
	var swing_nudge = 0.0
	swing_nudge = get_input()*player.swingSpeed
	print(radial_velocity)
	
	#var myUp = player.global_position - targetPosition
	#player.look_at(targetPosition)
	#player.rotate(PI/2)
	
	player.velocity += radius.normalized() * -(radial_velocity)
	
	if player.global_position.distance_to(targetPosition) != ropeLength:
		print("adjust")
		player.global_position = targetPosition + radius.normalized() * ropeLength
		
	player.velocity += (targetPosition - player.global_position).normalized() * (_delta) * 15000
