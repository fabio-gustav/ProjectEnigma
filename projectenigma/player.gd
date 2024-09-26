extends CharacterBody2D

@export var coyoteTime:float = 0.1
@export var jumpBufferTime:float = 0.1



@export var acceleration = .3
@export var jumpHeight:float = 512.0
@export var risingJumpTime:float = 0.4
@export var airspeed:float = 150.0
@export var airResistance:float = 0.05
@export var fallingJumpTime:float = 0.3
@export var dashDistance:float = 512.0
@export var speed = 300
@export var friction = .05
@export var swingSpeed:float = 64


@onready var grapple_cast: RayCast2D = $GrappleCast
@onready var coyote_timer: Timer = $coyoteTimer


var playerGrappled:bool = false
var jump_available:bool = false
var jump_buffer:bool = false
var dash_available:bool = false
var grapple_target:StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()



func coyoteTimeout() -> void:
	jump_available = false
	

func on_jump_buffer_timeout()->void:
	jump_buffer = false
