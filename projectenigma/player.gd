extends CharacterBody2D

@export var speed = 400
@export var gravity = 2620
@export var friction = .3
@export var acceleration = .3
@export var jump = 500;
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
func _physics_process(delta):
	velocity.y += delta * gravity
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = -jump;
	if is_on_floor():
		velocity.x = lerp(velocity.x,velocity.x+(get_input()*speed),acceleration) 
		velocity.x  = lerp(velocity.x, 0.0, friction)
	move_and_slide()
	
	
