extends Area2D

#@onready var player:Player = parent
@onready var label = $Label

const base_text = "[E] to "

var active_areas: Array[InteractionArea] = []
var can_interact = true

func _ready() -> void:
	connect("area_entered",register_area)
	connect("area_exited",unregister_area)

func register_area(area: Area2D):
	print(str(area) + " entered interaction manager")
	if area is InteractionArea:
		active_areas.push_back(area)

func unregister_area(area: Area2D):
	
	if area is InteractionArea:
		var index = active_areas.find(area)
		if index != 1:
			active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 && can_interact:
		#active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position.y -= 36
		label.global_position.x -= label.size.x/2
		label.show()
	else:
		pass
		label.hide()

#func _sort_by_distance_to_player(area1, area2):
	#var area1_to_player = player.global_position.distance_to(area1.global_position)
	#var area2_to_player = player.global_position.distance_to(area2.global_position)
	#return area1.global_position < area2.global_position
	#
func _input(event):
	if Dialogic.current_timeline != null:
		return
	
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			Dialogic.start(active_areas[0].timeline_name)
