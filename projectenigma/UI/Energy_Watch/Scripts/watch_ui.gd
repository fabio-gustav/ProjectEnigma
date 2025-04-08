extends Sprite2D

var current_health:float
var health_icon:Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeftCap.position.x -= 200*PlayerVariables.max_health
	$HealthEmpty.region_rect.size = Vector2(200*PlayerVariables.max_health,360)
	SignalBus.connect("health_changed",on_health_change)
	$RightCap.position.x += 200*PlayerVariables.max_energy
	$EnergyEmpty.region_rect.size = Vector2(200*PlayerVariables.max_energy,360)
	$EnergyEmpty/EnergyFull.region_rect.size = Vector2(200*PlayerVariables.max_energy,360)

func on_health_change(health:int):
	current_health = health
	PlayerVariables.health = current_health
	$HealthEmpty/HealthFull.region_rect.size = Vector2(200*current_health,360)
	
