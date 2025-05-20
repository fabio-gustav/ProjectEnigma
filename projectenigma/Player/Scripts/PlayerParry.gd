extends State

@export var grapple_state: State
@export var fall_state: State
@export var ride_state: State

@onready var jumpGravity:float

func init() -> void:
	jumpGravity = ((-2.0 * parent.jumpHeight) / (parent.risingJumpTime * parent.risingJumpTime)) * -1.0

func enter():
	super()
	var direction = parent.player_look()
	if parent.velocity.length() < (6000-parent.velocity.length()):	
		parent.velocity = (((-1*direction) * parent.velocity.length()) + ((-1*direction) * 6000))
	else:
		parent.velocity = ((-1*direction) * parent.velocity.length())
	parent.jump_available = false
	
func exit():
	parent.velocity.y = 0.0
	jumpGravity = ((-2.0 * parent.jumpHeight) / (parent.risingJumpTime * parent.risingJumpTime)) * -1.0

func process_input(event: InputEvent) -> State:
	if parent.grapple_check() and Input.is_action_just_pressed("grapple"):
		return grapple_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += jumpGravity * delta
	parent.velocity.x = lerp(parent.velocity.x,parent.velocity.x+(get_movement_input()*parent.airspeed),parent.acceleration)
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.airResistance)
	
	if parent.velocity.y >= 0.0:
		return fall_state
	return null
