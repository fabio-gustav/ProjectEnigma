extends Control

@onready var button1 = $Resume
@onready var button2 = $Options
@onready var button3 = $QuitGame
@onready var buttons = [button1, button2, button3]
@onready var opened
@onready var selection = 0;#starts at first button at zero, increments by 1 for each button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		switch()
	if opened:
		if Input.is_action_just_pressed("up"):
			select(-1)#-1 represents going up the list
		if Input.is_action_just_pressed("down"):
			select(1)# 1 represents going down the list
		if Input.is_action_just_pressed("jump"):
			buttons[selection].pressed.emit()
		
func switch():
	opened = !opened
	if opened:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false
		
#for controller to traverse menu
func select(direction):
	if selection == 0 and direction == -1:
		return
	if selection == 2 and direction == 1:
		return
	buttons[selection].set("theme_override_colors/font_color",Color(255,255,255))
	selection += direction;
	buttons[selection].set("theme_override_colors/font_color",Color(255,255,0))
	
func resume():
	switch()

func options():
	print("imagine having a sub options menu, couldn't be me")
	
func quitGame():
	get_tree().quit()
	
