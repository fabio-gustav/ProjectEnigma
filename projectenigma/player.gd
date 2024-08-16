extends CharacterBody2D

@export var speed = 400
@export var gravity = 2620
@export var friction = .3
@export var acceleration = .3
@export var jumpForce = 500;
@export var coyoteTime:float = 0.1
@export var jumpBufferTime:float = 0.1

@onready var coyote_timer: Timer = $coyoteTimer


var jump_available:bool = false
var jump_buffer:bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	if is_on_floor():
		var input_direction = Input.get_axis("left","right")
		return input_direction
	else:
		return 0.0
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += delta * gravity
		if jump_available && coyote_timer.is_stopped():
			coyote_timer.start(coyoteTime)
	else:
		jump_available = true
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false
	
	
	if Input.is_action_just_pressed("jump") && jump_available:
		jump()
		if !jump_available:
			jump_buffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(on_jump_buffer_timeout)
		
		
	if is_on_floor():
		velocity.x = lerp(velocity.x,velocity.x+(get_input()*speed),acceleration) 
		velocity.x  = lerp(velocity.x, 0.0, friction)
	move_and_slide()
	

func jump() -> void:
	velocity.y = -jumpForce;
	jump_available = false



func coyoteTimeout() -> void:
	jump_available = false
	

func on_jump_buffer_timeout()->void:
	pass
