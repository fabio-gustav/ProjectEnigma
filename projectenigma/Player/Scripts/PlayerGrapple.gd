extends State

class_name PlayerGrapple

@onready var fallGravity:float = ((-2.0 * player.jumpHeight) / (player.fallingJumpTime * player.fallingJumpTime)) * -1

var target:StaticBody2D
var targetPosition:Vector2
var ropeLength:float
var stop
var icon : Sprite2D

func Enter():
	player.velocity = Vector2(0,0)
	player.playerGrappled = true
	targetPosition = player.grapple_target.global_position
	ropeLength = player.global_position.distance_to(targetPosition)


func Exit():
	player.playerGrappled = false
	

func Update():
	pass

func physicsUpdate(_delta:float):
	if Input.is_action_just_pressed("grapple"):
		stop = true
		Exit()
		Transitioned.emit("grappling","falling")
		return
		
	
	player.velocity.y += fallGravity * _delta
	swing(_delta)
	player.velocity *= 0.98
	if player.is_on_floor():
		Exit()
		Transitioned.emit("grappling","idle")
		return
	
	if Input.is_action_just_pressed("dash") && player.dash_available:
		Exit()
		Transitioned.emit("dashing","dashing")
		return
	
	if Input.is_action_just_pressed("jump"):
		Exit()
		Transitioned.emit("grappling","jumping")
		return
		
	if Input.is_action_just_pressed("grapplepull"):
		Transitioned.emit("grappling","grapplepulling")
		return
	



func endGrapple():
	player.playerGrappled = false
	
	
func swing(_delta):
	var radius = player.global_position - targetPosition
	if player.velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(player.velocity) / (radius.length()*player.velocity.length()))
	var radial_velocity = cos(angle) * player.velocity.length()
	#var radial_velocity = fallGravity
	#var radial_velocity = player.global_position.dot(-targetPosition) * radius.normalized(
	
	
	#var myUp = player.global_position - targetPosition
	#player.look_at(targetPosition)
	#player.rotate(PI/2)
	
	player.velocity += radius.normalized() * -(radial_velocity)
	
	if player.global_position.distance_to(targetPosition) != ropeLength:
	#print("adjust")
		player.global_position = targetPosition + radius.normalized() * ropeLength
		
	player.velocity += (targetPosition - player.global_position).normalized() * (_delta) * 15000
	
	if Input.is_action_pressed("right") and player.velocity.x > 0:
		player.velocity+= player.velocity.normalized() * player.swing_speed * radius.length()
	
	if Input.is_action_pressed("left") and player.velocity.x < 0:
		player.velocity+= player.velocity.normalized() * player.swing_speed * radius.length()
	#print(player.velocity)
