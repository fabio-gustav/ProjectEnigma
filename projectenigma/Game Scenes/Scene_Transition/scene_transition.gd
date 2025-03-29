extends Control

@onready var background = $ColorRect
var loaded = false
var level = ""

func _ready() -> void:
	SignalBus.connect("sceneTransition", loadLevel)
	SignalBus.connect("loading", loadedSwap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (loaded):# switces between fading in or fading out depending on if it is loaded or not
		background.set_self_modulate(lerp(background.get_self_modulate(), Color(1,1,1,0), 0.2))
	else:
		background.set_self_modulate(lerp(background.get_self_modulate(), Color(0,0,0,1), 0.2))
		
func loadLevel(level):
	loadedSwap()
	await get_tree().create_timer(0.3).timeout # arbitray delay for no reason
	get_tree().change_scene_to_file(level)
	
func loadedSwap():
	loaded = !loaded
		
		
