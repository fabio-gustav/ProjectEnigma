extends Path2D

#note: Speed is dependant on the length of the path. If you have a longer path and want a slow moving platform, you'll need to have a slower speed
@export var speed : float = 1
var loop = false
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer


func _ready():
	if (!loop):
		animation.play("back_and_forth")
		animation.speed_scale = speed
		set_process(false)
