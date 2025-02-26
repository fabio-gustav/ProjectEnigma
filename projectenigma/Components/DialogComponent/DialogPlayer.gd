extends CanvasLayer

@export_file("*.json") var scene_text_file

var scene_text = {}
var selected_text = []
var in_progress = false

@onready var background = $Background
@onready var text_label = $TextLabel



func _ready():
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.connect("display_dialog",on_display_dialog)
	

func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		background.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()

func load_scene_text():
	var json = JSON.new()
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	json.parse(file.get_as_text(),true)
	return json.data

func show_text():
	text_label.text = selected_text.pop_front()
	for line in selected_text:
			print(line)

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
