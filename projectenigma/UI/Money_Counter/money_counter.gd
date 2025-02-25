extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_child(0).frame = PlayerVariables.money % 10
	get_child(1).frame = (PlayerVariables.money/10) % 10
	get_child(2).frame = (PlayerVariables.money/100) % 10
	get_child(3).frame = (PlayerVariables.money/1000) % 10
