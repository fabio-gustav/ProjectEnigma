extends Path2D


@export var speed :float = 1
var onPlatform = false
var goBack = false# used for detecting whent the animation finishes so we don't jump around everywhere
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var platform = $AnimatableBody2D


#Note: back and forth isn't "and forth" for this platform, I was just too lazy to change the name
func _ready():
	animation.play("back_and_forth")
	animation.speed_scale = speed
	animation.pause()
	

# stupid function
func _physics_process(delta: float) -> void:
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
				
func _on_area_2d_area_entered(area: Area2D) -> void:
	onPlatform = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	onPlatform = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	goBack = true;
