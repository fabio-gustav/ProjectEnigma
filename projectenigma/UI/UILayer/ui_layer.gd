extends CanvasLayer

func _ready():
	$".".visible = true;
	SignalBus.emit_signal("loading")
