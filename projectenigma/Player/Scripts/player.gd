extends CharacterBody2D


#Jump Variables
@export var coyoteTime:float = 0.2
@export var jumpBufferTime:float = 0.1
@export var jumpHeight:float = 768
@export var risingJumpTime:float = 0.4
@export var airResistance:float = 0.005
@export var fallingJumpTime:float = 0.3
@onready var coyote_timer: Timer = $CoyoteTimer
@export var airspeed:float = 50.0
var jump_available:bool = false
var jump_buffer:bool = false

#Parry Variables
@export var parry_time:float = 0.2
@export var parry_buffer_time:float = 0.1
@onready var parry_timer: Timer = $ParryTimer
var parry_available:bool = true
var parry_buffer:bool = false


#Dash Variables
@export var dashCooldown:float = 0.5
@export var dashDistance:float = 1024
var dash_available:bool = true
var dash_cool:bool = false


#Movement Variables
@export var acceleration = .05
@export var walk_speed = 1042
@export var run_speed = 2048
@export var run_acceleration = .25
@export var friction = .2

#Grapple Variables
@export var swing_speed:float = 64
@export var slide_friction:float = 0.01
@export var grapple_pull:float = 1024
@export var grapple_pull_speed:float = 800
@onready var grapple_cast: RayCast2D = $GrappleCast
var playerGrappled:bool = false
var grapple_target:StaticBody2D
var grapple_icon:Sprite2D
@onready var marker = preload("res://Player/Sprites/Grapple_Point_Dot.png")

#Sprite Variables
var x_input:float = 0.0
@onready var player_sprite = $PlayerSprite
#@onready var head = $PlayerSprite/Torso/Head
@onready var torso = $PlayerSprite/Torso
@onready var arm = $PlayerSprite/Torso/Arm
@onready var aim_pivot = $AimPivot


# Called when the node enters the scene tree for the first time.
func _ready():
	set_floor_max_angle(1.48353)
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
	print("jump no longer available")
	jump_available = false
	
func parry_timeout() -> void:
	print("parry no longer available")
	

func on_jump_buffer_timeout()->void:
	jump_buffer = false

func on_parry_buffer_timeout()->void:
	parry_buffer = false


func player_look():
	var thing = Input.get_vector("left","right","up","down")
	#print(thing)
	return thing


func on_dash_cooldown_timer_timeout() -> void:
	dash_cool = true
	
func death() -> void:
	SignalBus.emit_signal("sceneTransition","res://Game Scenes/bettertestlevel.tscn")
