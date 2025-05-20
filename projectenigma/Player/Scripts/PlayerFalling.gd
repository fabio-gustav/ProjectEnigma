extends State

@export var grapple_state: State
@export var parry_state: State
@export var idle_state: State
@export var jump_state: State
@export var ride_state: State


@onready var fallGravity:float 
func init() -> void:
	fallGravity = ((-2.0 * parent.jumpHeight) / (parent.fallingJumpTime * parent.fallingJumpTime)) * -1.0

func enter():
	super()
	if parent.jump_available:
		parent.coyote_timer.start(parent.coyoteTime)

func exit():
	#parent.parry_timer.start(parent.parry_time)
	#Transitioned.emit("falling","idle")
	pass

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.jump_available:
			return jump_state
		parent.jump_buffer = true
		parent.get_tree().create_timer(parent.jumpBufferTime).timeout.connect(parent.on_jump_buffer_timeout)
		return null
	if parent.grapple_check() and Input.is_action_just_pressed("grapple"):
		return grapple_state
	#if parent.parry_available and Input.is_action_just_pressed("parry"):
		##legs.stop()
		##arm.stop()
		#if parent.parry_buffer or parent.is_on_wall():
			#return parry_state
		#parent.parry_buffer = true
		#parent.get_tree().create_timer(parent.parry_buffer_time).timeout.connect(parent.on_parry_buffer_timeout)
	return null

func process_physics(delta: float):
	parent.velocity.y += fallGravity * delta
	parent.velocity.x = lerp(parent.velocity.x,parent.velocity.x+(get_movement_input()*parent.airspeed),parent.acceleration)
	parent.velocity.x  = lerp(parent.velocity.x, 0.0, parent.airResistance)
	
	if parent.is_on_floor():
		if parent.is_riding:
			return ride_state
		else:
			return idle_state
