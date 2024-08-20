extends CharacterBody2D

@export var speed = 400
@export var airspeed:float = 50
@export var friction = .3
@export var airResistance:float = 0.05
@export var acceleration = .3
@export var coyoteTime:float = 0.1
@export var jumpBufferTime:float = 0.1
@export var jumpHeight:float = 100.0
@export var risingJumpTime:float = 0.5
@export var fallingJumpTime:float = 0.4
@export var dashDistance:float = 256

@onready var coyote_timer: Timer = $coyoteTimer
@onready var jumpVelocity:float = ((2.0 * jumpHeight) / risingJumpTime) * -1.0
@onready var jumpGravity:float = ((-2.0 * jumpHeight) / (risingJumpTime * risingJumpTime)) * -1.0
@onready var fallGravity:float = ((-2.0 * jumpHeight) / (fallingJumpTime * fallingJumpTime)) * -1.0
@onready var dashVelocity:float = ((2.0 * dashDistance) / risingJumpTime)


var jump_available:bool = false
var jump_buffer:bool = false
var dash_available:bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input() -> float:
	var input_direction = Input.get_axis("left","right")
	return input_direction
	
func get_dash_input() -> Vector2:
	var input_direction = Input.get_vector("left","right","up","down").normalized()
	return input_direction
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += delta * getGravity()
		
		if jump_available && coyote_timer.is_stopped():
			coyote_timer.start(coyoteTime)
	else:
		dash_available = true
		jump_available = true
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false
	
	
	if Input.is_action_just_pressed("jump"):
		if jump_available:
			jump()
		else:
			jump_buffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(on_jump_buffer_timeout)
			
	if Input.is_action_just_pressed("dash") && dash_available:
		dash()
		
		
		
		
	if is_on_floor():
		velocity.x = lerp(velocity.x,velocity.x+(get_input()*speed),acceleration) 
		velocity.x  = lerp(velocity.x, 0.0, friction)
	else:
		velocity.x = lerp(velocity.x,velocity.x+(get_input()*airspeed),acceleration)
		velocity.x  = lerp(velocity.x, 0.0, airResistance)
		
	
	move_and_slide()
	

func getGravity()->float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

func jump() -> void:
	velocity.y = jumpVelocity
	jump_available = false

func dash() -> void:
	if velocity.y > 0:
		velocity.y = 0
	velocity += get_dash_input() * dashVelocity
	dash_available = false


func coyoteTimeout() -> void:
	jump_available = false
	

func on_jump_buffer_timeout()->void:
	jump_buffer = false
