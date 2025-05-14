extends Path2D

@export var speed :float = 1
@export var haveFloors : bool = false # set to true if you want to have floors

@export var floor0Bound :float = 0 # to represent the end or begining, use -1, other wise the a percentage to represent how far up from 0 to 1.00
@export var floor1Bound :float = -1
@export var floor2Bound :float = -1
@export var floor3Bound :float = -1
@export var floor4Bound :float = -1
@export var floor5Bound :float = -1
@export var floor6Bound :float = -1
@export var floor7Bound :float = -1
@export var floor8Bound :float = -1
@export var floor9Bound :float = -1

var floors

var onPlatform = false
var goBack = false# used for detecting whent the animation finishes so we don't jump around everywhere
var currentFloor : int = 0
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var platform = $AnimatableBody2D

#Note: back and forth isn't "and forth" for this platform, I was just too lazy to change the name
func _ready():
	floors = [floor0Bound, floor1Bound, floor2Bound, floor3Bound, floor4Bound, floor5Bound, floor6Bound, floor7Bound, floor8Bound, floor9Bound]
	animation.play("back_and_forth")
	animation.speed_scale = speed
	animation.pause()
	
func _physics_process(delta: float) -> void:
	if(haveFloors):
		floorMovement()
	else:
		standardMovement()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	onPlatform = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	onPlatform = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	goBack = true;
	
#stupid function
func standardMovement():
	if (onPlatform == true && Input.is_action_just_pressed("interact")):
		if(animation.is_playing()):
			animation.pause()
		else:
			if(Input.is_action_pressed("down")):
				if(goBack):
					if(animation.speed_scale < 0):
						return
					animation.play("back_and_forth", -1, 1, true)
					goBack = false
				else:
					animation.play("back_and_forth")
				animation.speed_scale = -speed
			if(Input.is_action_pressed("up")):
				if(goBack):
					if(animation.speed_scale > 0):
						return
					animation.play("back_and_forth", -1, 1, false)
					goBack = false
				else:
					animation.play("back_and_forth")
				animation.speed_scale = speed
	
func floorMovement():
	#floor handler
	print(path.progress_ratio)
	print(currentFloor)
	print(floors[currentFloor])
	if(floors[currentFloor] != 1.00):
		if(path.progress_ratio >= floors[currentFloor+1]):
			animation.pause()
			currentFloor += 1
	if(floors[currentFloor] != 0):
		if(path.progress_ratio <= floors[currentFloor-1]):
			animation.pause()
			currentFloor -= 1
	#back to standard movement
	standardMovement()
	
