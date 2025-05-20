extends State

@export var fall_state: State
@export var grapple_pull_state: State
@export var jump_state: State
@export var idle_state: State

@onready var fallGravity:float 

var targetPosition:Vector2
var ropeLength:float
var icon: Sprite2D

func init() -> void:
	fallGravity = ((-2.0 * parent.jumpHeight) / (parent.fallingJumpTime * parent.fallingJumpTime)) * -1

func enter():
	super()
	parent.playerGrappled = true
	targetPosition = parent.grapple_target.global_position
	ropeLength = parent.global_position.distance_to(targetPosition)


func exit():
	parent.playerGrappled = false
	parent.is_riding = true	

func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed("grapple"):
		#return fall_state
	if Input.is_action_just_pressed("jump"):
		return jump_state
	if Input.is_action_just_pressed("grapplepull"):
		return grapple_pull_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += fallGravity * delta
	swing(delta)
	parent.velocity *= 0.98
	
	if parent.is_on_floor():
		return idle_state
	return null

func swing(_delta):
	var radius = parent.global_position - targetPosition
	if parent.velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(parent.velocity) / (radius.length()*parent.velocity.length()))
	var radial_velocity = cos(angle) * parent.velocity.length()
	
	parent.velocity += radius.normalized() * -(radial_velocity)
	
	if parent.global_position.distance_to(targetPosition) != ropeLength:
	#print("adjust")
		parent.global_position = targetPosition + radius.normalized() * ropeLength
		
	parent.velocity += (targetPosition - parent.global_position).normalized() * (_delta) * 15000
	
	#could probalby lerp this to a max speed
	if Input.is_action_pressed("right") and parent.velocity.x > 0:
		parent.velocity+= parent.velocity.normalized() * parent.swing_speed * radius.length()
	
	if Input.is_action_pressed("left") and parent.velocity.x < 0:
		parent.velocity+= parent.velocity.normalized() * parent.swing_speed * radius.length()
