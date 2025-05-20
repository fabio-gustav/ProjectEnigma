extends State

@export var jump_state: State
@export var fall_state: State
@export var walk_state: State
@export var parry_state: State

func enter() -> void:
	super()
	parent.jump_available = true

func process_input(event: InputEvent) -> State:
	if parent.jump_buffer or Input.is_action_just_pressed("jump") :
		parent.jump_buffer = false
		#legs.stop()
		#arm.stop()
		return jump_state
	if parent.velocity.x != 0.0 or get_movement_input() != 0.0:
		return walk_state
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		#Start coyote timer
		if parent.jump_available:
			parent.coyote_timer.start(parent.coyoteTime)
		return fall_state
		
	parent.velocity.x  = lerp(parent.velocity.x, 0.0, parent.friction) #calculate friction
	parent.jump_available = true 
	parent.coyote_timer.stop()
	return null
