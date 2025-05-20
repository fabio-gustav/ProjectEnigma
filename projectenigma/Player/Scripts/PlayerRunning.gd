extends State

@export var jump_state: State
@export var fall_state: State
@export var idle_state: State
@export var parry_state: State
@export var slide_state: State
@export var walk_state: State
@export var ride_state: State


func enter():
	super()
	#legs.play("Running")
	#arm.play("Running")

func exit():
	#legs.stop()
	#arm.stop()
	pass

func process_input(event: InputEvent) -> State:
	if parent.jump_buffer or Input.is_action_just_pressed("jump") :
		parent.jump_buffer = false
		#legs.stop()
		#arm.stop()
		return jump_state
	if Input.is_action_pressed("slide"):
		return slide_state
	#if parent.parry_available and Input.is_action_just_pressed("parry"):
		##legs.stop()
		##arm.stop()
		#return parry_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.x = lerp(parent.velocity.x,(get_movement_input()*parent.run_speed),parent.run_acceleration)
	
	if get_movement_input() == 0.0:
		parent.velocity.x  = lerp(parent.velocity.x, 0.0, parent.run_friction)
	#parent.move_and_slide()
	if !parent.is_on_floor():
		#Start coyote timer
		if parent.jump_available:
			parent.coyote_timer.start(parent.coyoteTime)
		return fall_state
	

	if abs(parent.velocity.x) < parent.walk_speed:
		#legs.stop()
		#arm.stop()
		return walk_state
	#if abs(parent.velocity.x) > parent.run_speed - 400:
		##legs.stop()
		##arm.stop()
		#return surf_state
	return null
