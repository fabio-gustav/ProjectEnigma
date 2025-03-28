extends CanvasLayer

func _ready():
	SignalBus.emit_signal("loading")
