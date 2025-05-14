extends State

@export var fall_state: State

var targetPosition: Vector2

@export var grapplejumpHeight:float
@export var risinggrappleJumpTime:float
@onready var jumpVelocity:float
@onready var jumpGravity:float

func init() -> void:
	grapplejumpHeight = 768
	risinggrappleJumpTime = 0.4
	jumpVelocity = ((2.0 * parent.jumpHeight) / parent.risingJumpTime) * -1.0
	jumpGravity = ((-2.0 * parent.jumpHeight) / (parent.risingJumpTime * parent.risingJumpTime)) * -1.0

func enter():
	super()
	var direction = parent.player_look()
	targetPosition = parent.grapple_target.global_position
	parent.jump_available = false
	parent.velocity = Vector2(0,0)
	
func exit():
	parent.playerGrappled = false


func process_physics(delta: float) -> State:
	if targetPosition.y < parent.global_position.y:
		parent.velocity += (parent.global_position.direction_to(targetPosition)) * parent.grapple_pull_speed
		return null
	else:
		return fall_state
	
