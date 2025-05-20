extends State

@export var jump_state: State
@export var fall_state: State
@export var idle_state: State
@export var parry_state: State
@export var run_state: State


func enter():
	super()
	#legs.play("Running")
	#arm.play("Running")

func exit():
	parent.wipeout = false
	parent.is_wobbling = false
	#legs.stop()
	#arm.stop()
	pass

func process_input(event: InputEvent) -> State:
	if parent.jump_buffer or Input.is_action_just_pressed("jump") :
		parent.jump_buffer = false
		#legs.stop()
		#arm.stop()
		return jump_state
	if Input.is_action_just_pressed("parry") or parent.parry_buffer:
		if parent.is_on_wall():
			return parry_state
		parent.parry_buffer = true
		parent.get_tree().create_timer(parent.parry_buffer_time).timeout.connect(parent.on_parry_buffer_timeout)
		#legs.stop()
		#arm.stop()
		return null
	return null

func process_physics(delta: float) -> State:
	parent.velocity.x = lerp(parent.velocity.x,(get_movement_input()*parent.ride_speed),parent.ride_acceleration)
	
	if parent.wipeout:
		return run_state
	
	if get_movement_input() == 0.0:
		parent.velocity.x  = lerp(parent.velocity.x, 0.0, parent.ride_friction)
	#parent.move_and_slide()
	if !parent.is_on_floor():
		#Start coyote timer
		if parent.jump_available:
			parent.coyote_timer.start(parent.coyoteTime)
		return fall_state
	
	if abs(parent.velocity.x) < parent.run_speed:
		#legs.stop()
		#arm.stop()
		parent.get_tree().create_timer(parent.wobble_time).timeout.connect(_on_wobble_fall)
		parent.is_wobbling = true
		return null
	elif parent.is_wobbling:
		parent.is_wobbling = false
		return null
	return null


func _on_wobble_fall():
	if parent.is_wobbling:
		print("Player Fell")
		parent.is_wobbling = false
		parent.wipeout = true
