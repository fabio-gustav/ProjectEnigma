extends Sprite2D

var speed_number = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_rotation_degrees(-121)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	SignalBus.connect("playerVelocity",update_velocity)
	
	var new_rotation = speed_number/100
	set_rotation_degrees(-121+new_rotation)

func update_velocity(speed):
	speed_number = speed
