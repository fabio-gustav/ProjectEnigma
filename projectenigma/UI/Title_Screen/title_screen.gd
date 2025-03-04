extends Control

@onready var loadLevelButton = $"MainMenu/Load Level"
@onready var quitGameButton = $"MainMenu/Quit Game"
@onready var optionsButton = $MainMenu/Options

@onready var Menus = $Menus
@onready var level = "res://Game Scenes/bettertestlevel.tscn" # change this to change the starting level
@onready var activeButtons = [loadLevelButton, optionsButton, quitGameButton]
@onready var optionsButtons = []
@onready var selection = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		select(-1)#-1 represents going up the list
	if Input.is_action_just_pressed("down"):
		select(1)# 1 represents going down the list
	if Input.is_action_just_pressed("jump"):
		activeButtons[selection].pressed.emit()
		
#for controllers to traverse menu by pressing up and down
func select(direction):
	if selection == 0 and direction == -1:
		return
	if selection == activeButtons.size()-1 and direction == 1:
		return
	activeButtons[selection].set("theme_override_colors/font_color",Color(255,255,255))
	selection += direction;
	activeButtons[selection].set("theme_override_colors/font_color",Color(255,255,0))
	
#menu is the array of buttons you want to go to
func subMenu(menu):
	activeButtons[selection].set("theme_override_colors/font_color",Color(255,255,255))
	selection = 0
	for button in activeButtons:
		button.hide()
	activeButtons = menu
	for button in activeButtons:
		button.show()
	activeButtons[selection].set("theme_override_colors/font_color",Color(255,255,0))
	
func loadLevel():
	get_tree().change_scene_to_file(level)

func options():#no
	return
	subMenu(optionsButtons)
	
func quitGame():
	get_tree().quit()
