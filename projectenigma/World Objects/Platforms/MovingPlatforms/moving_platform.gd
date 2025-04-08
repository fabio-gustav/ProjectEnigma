extends Path2D


var speed = 2
var loop = false
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer


func _ready():
	if (!loop):
		animation.play("back_and_forth")
		set_process(false)

	
func _process(_delta):
	path.progress += speed
