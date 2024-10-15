extends CharacterBody2D

@export var coyoteTime:float = 0.2
@export var jumpBufferTime:float = 0.1
#testing things

@export var acceleration = .25
@export var jumpHeight:float = 768
@export var risingJumpTime:float = 0.4
@export var airspeed:float = 50.0
@export var airResistance:float = 0.005
@export var fallingJumpTime:float = 0.3
@export var dashDistance:float = 1024
@export var speed = 1542
@export var friction = .2
@export var swing_speed:float = 64
@export var slide_friction:float = 0.01
@export var grapple_pull:float = 1024
@export var wallslide_gravity:float = 5500
@export var grapple_pull_speed:float = 800




@onready var grapple_cast: RayCast2D = $GrappleCast
@onready var coyote_timer: Timer = $coyoteTimer


var playerGrappled:bool = false
var jump_available:bool = false
var jump_buffer:bool = false
var dash_available:bool = false
var grapple_target:StaticBody2D

var x_input:float = 0.0
@onready var player_sprite = $PlayerSprite
@onready var head = $PlayerSprite/Torso/Head
@onready var torso = $PlayerSprite/Torso
@onready var arm = $PlayerSprite/Torso/Arm
@onready var aim_pivot = $AimPivot
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	print(is_on_wall_only())
	grapple_cast.look_at((10*player_look())+global_position)
	move_and_slide()



func coyoteTimeout() -> void:
	jump_available = false
	

func on_jump_buffer_timeout()->void:
	jump_buffer = false


func player_look():
	var thing = Input.get_vector("left","right","up","down")
	print(thing)
	return thing
