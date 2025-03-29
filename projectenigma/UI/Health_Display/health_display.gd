extends CanvasGroup

var current_health:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = PlayerVariables.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_uncharged_ready() -> void:
	SignalBus.connect("health_changed",on_health_change)
	
func on_health_change(health:int):
	current_health = health
	PlayerVariables.health = current_health
	get_child(0).set_region_rect(Rect2(0,0,200*current_health,200))
	
