extends Sprite2D

var speed_number = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("playerVelocity",update_velocity)
	set_rotation_degrees(-121)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	var new_rotation = speed_number/50
	set_rotation_degrees(-121+new_rotation)

func update_velocity(speed):
	speed_number = speed
