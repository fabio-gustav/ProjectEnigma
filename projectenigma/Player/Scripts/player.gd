extends CharacterBody2D

@export var coyoteTime:float = 0.2
@export var jumpBufferTime:float = 0.1
@export var dashCooldown:float = 0.5
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
var dash_available:bool = true
var dash_cool:bool = false
var grapple_target:StaticBody2D
var grapple_icon:Sprite2D

@onready var marker = preload("res://Player/Sprites/Grapple_Point_Dot.png")

var x_input:float = 0.0
@onready var player_sprite = $PlayerSprite
@onready var head = $PlayerSprite/Torso/Head
@onready var torso = $PlayerSprite/Torso
@onready var arm = $PlayerSprite/Torso/Arm
@onready var aim_pivot = $AimPivot


# Called when the node enters the scene tree for the first time.
func _ready():
	floor_snap_length = 10.0
	floor_stop_on_slope = false
	grapple_icon = Sprite2D.new()
	grapple_icon.visible = false
	grapple_icon.position = global_position
	grapple_icon.texture = marker
	grapple_icon.scale = Vector2(0.4,0.4)
	add_sibling.call_deferred(grapple_icon)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	if (dash_cool and is_on_floor()):
		dash_available = true
	grapple_check()
	grapple_cast.look_at((10*player_look())+global_position)
	move_and_slide()
	SignalBus.emit_signal("playerVelocity",velocity.length())
	
	#addition to connect with signal bus to give debug menu player movement data
	SignalBus.emit_signal("debugData",[velocity.x, velocity.y])

func grapple_check():
	var penits:StaticBody2D = grapple_cast.get_collider()
	
	if penits != null and !penits.get_collision_layer_value(1):
		if grapple_target != penits:
			
			grapple_icon.position = penits.global_position
			grapple_icon.visible = true
		else:
			pass
		if !playerGrappled:
			grapple_target = penits
		return true
	else:
		if !playerGrappled:
			grapple_target = null
		grapple_icon.visible = false
		return false

func coyoteTimeout() -> void:
	jump_available = false
	

func on_jump_buffer_timeout()->void:
	jump_buffer = false


func player_look():
	var thing = Input.get_vector("left","right","up","down")
	#print(thing)
	return thing


func on_dash_cooldown_timer_timeout() -> void:
	dash_cool = true
