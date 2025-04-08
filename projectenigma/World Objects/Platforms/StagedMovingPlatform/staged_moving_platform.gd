extends Path2D


var speed = 2
var stage = 0
var loop = false
var onPlatform = false
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var platform = $AnimatableBody2D


func _ready():
	animation.play("back_and_forth")
	animation.pause()
	

# used if you want a looping path
func _process(_delta):
	if (onPlatform == true && Input.is_action_just_pressed("interact")):
		if(animation.is_playing()):
			animation.pause()
		else:
			animation.play("back_and_forth")
				
			
			
func _on_area_2d_area_entered(area: Area2D) -> void:
	onPlatform = true
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	onPlatform = false
