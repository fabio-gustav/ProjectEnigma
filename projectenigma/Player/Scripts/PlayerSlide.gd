extends State

@export var idle_state: State
@export var walk_state: State
@export var fall_state: State
@export var jump_state: State
@export var ride_state: State

@onready var fallGravity:float
@onready var floor_angle: float

func init() -> void:
	fallGravity = ((-2.0 * parent.jumpHeight) / (parent.fallingJumpTime * parent.fallingJumpTime)) * -1.0
	floor_angle = parent.get_floor_angle()

func enter():
	super()
	parent.floor_snap_length = 100.0

func exit():
	parent.floor_snap_length = 10.0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("parry"):
		if PlayerVariables.energy > 0:
			PlayerVariables.energy -= 1
			SignalBus.emit_signal("energy_changed",PlayerVariables.energy)
			return ride_state
		else:
			return null
		return ride_state
	if parent.jump_buffer or Input.is_action_just_pressed("jump") :
		parent.jump_buffer = false
		#legs.stop()
		#arm.stop()
		return jump_state
	return null

func process_physics(delta: float) -> State:
	floor_angle = parent.get_floor_angle()
	if floor_angle >= 0.1:
		parent.velocity.x += (parent.get_floor_normal() * fallGravity * delta).x
	if abs(parent.velocity.x) >= 0.001:
		parent.velocity.x = lerp(parent.velocity.x,0.0,parent.slide_friction)
	else:
		return idle_state
	parent.apply_floor_snap()
		
	if !parent.is_on_floor():
		return fall_state
	
	if !Input.is_action_pressed("slide"):
		return idle_state
	return null
