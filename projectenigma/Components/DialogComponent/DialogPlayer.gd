extends Control



@export_file("*.json") var scene_text_file

var loadLevel
var scene_text = {}
var selected_text = []
var in_progress = false

@onready var background = $Background
@onready var text_label = $TextLabel
@onready var timer = $LetterDisplayTimer
@onready var audio = $AudioStreamPlayer

var letter_index:int = 0

@export var letter_time:float = 0.03
@export var space_time:float = 0.06
@export var punctuation_time:float = 0.2

var finished_displaying = false

var text_to_display = ""

func _ready():
	scene_text_file = "res://JSON/" + get_tree().get_current_scene().get_name() + ".json"
	print(scene_text_file)
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.connect("display_dialog",on_display_dialog)
	

func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		background.show()
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
	text_to_display = selected_text.pop_front()
	_display_letter()
	for line in selected_text:
			print(line)

func _display_letter():
	text_label.text += text_to_display[letter_index]
	audio.pitch_scale = randf_range(0.9,1.1)
	audio.play()
	
	letter_index +=1
	if letter_index >= text_to_display.length():
		finished_displaying = true
		return
	
	match text_to_display[letter_index]:
		"!",".",",","?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
func next_line():
	if selected_text.size() > 0:
		text_label.text = ""
		letter_index = 0
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	letter_index = 0
	background.visible = false
	in_progress = false
	get_tree().paused = false


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
