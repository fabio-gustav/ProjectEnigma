extends Area2D

@export var dialog_key = ""
@export var cooldown:float

var area_active = false
var dialog_finished = true

func _ready() -> void:
	set_process_input(true)
	SignalBus.connect("dialog_finished",_on_dialog_finished)


func _input(event: InputEvent) -> void:
	if area_active and event.is_action_pressed("interact") and dialog_finished:
		dialog_finished = false
		
		SignalBus.emit_signal("display_dialog",dialog_key)

func _on_DialogArea_entered(area: Area2D) -> void:
	area_active = true

func _on_dialog_finished():
	dialog_finished = true

func _on_DialogArea_exited(area: Area2D) -> void:
	area_active = false
