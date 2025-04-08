extends Control

@onready var Menus = $Menus

#for main menu
@onready var Resume = $Menus/MainPauseMenu/Resume
@onready var Options = $Menus/MainPauseMenu/Options
@onready var QuitGame = $Menus/MainPauseMenu/QuitGame

#for options meny
@onready var BackToMain = $"Menus/OptionsMenu/Back(toMain)"
@onready var SoundSettings = $Menus/OptionsMenu/SoundSettings
@onready var VideoSettings = $Menus/OptionsMenu/VideoSettings
@onready var Controls = $Menus/OptionsMenu/Controls
@onready var Debug = $Menus/OptionsMenu/Debug

#for debug menu
@onready var BackToOptions = $"Menus/DebugMenu/Back(toOptions)"
@onready var Money = $Menus/DebugMenu/Money
@onready var ToBetterTestLevel = $Menus/DebugMenu/ToBetterTestLevel
@onready var ToTestLevel = $Menus/DebugMenu/ToTestLevel
@onready var DebugText = $Menus/DebugMenu/DebugText
@onready var fishTest = $Menus/DebugMenu/FishTest

@onready var debugText  = $DebugText   #not a button
@onready var debugUpdateTimer = $DebugText/DebugUpdateTimer

@onready var mainButtons = [Resume, Options, QuitGame]#buttons available in the main pause menu
@onready var optionsButtons = [BackToMain, SoundSettings, VideoSettings, Controls, Debug ]#buttons that appear in sub-options menu
@onready var debugButtons = [BackToOptions, Money, ToBetterTestLevel, ToTestLevel, DebugText, fishTest]
@onready var activeButtons = mainButtons#buttons that will be iterated through for selection, set to mainButtons by defualt

@onready var opened = false
@onready var debugOn = false
@onready var selection = 0#starts at first button at zero, increments by 1 for each button
@onready var playerData = [1, 2] # to connect with signal bus


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackToMain.hide()
	SoundSettings.hide()
	VideoSettings.hide()
	Controls.hide()
	
	Debug.hide()
	debugText.hide()
	
	BackToOptions.hide()
	Money.hide()
	ToBetterTestLevel.hide()
	ToTestLevel.hide()
	DebugText.hide()
	fishTest.hide()
	
	
	SignalBus.connect("debugData", updatePlayerData)
	
	Menus.hide()


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
			activeButtons[selection].pressed.emit()
			
#called for pausing and unpausing
func switch():
	opened = !opened
	if opened:
		subMenu(mainButtons)
		Menus.show()
		get_tree().paused = true
	else:
		Menus.hide()
		get_tree().paused = false
		
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
	
func resume():
	switch()

func options():
	subMenu(optionsButtons)
	
func quitGame():
	get_tree().quit()
	
func backToMain():
	subMenu(mainButtons)
	
func soundSettings():
	pass
	
func videoSettings():
	pass

func controls():
	pass
	
func debug():
	subMenu(debugButtons)
	
func backToOptions():
	subMenu(optionsButtons)
	
func money():
	PlayerVariables.transaction(1)
	
func toTestLevel():
	get_tree().paused = false
	SignalBus.emit_signal("sceneTransition", "res://Game Scenes/testlevel.tscn")
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	
func toBetterTestLevel():
	get_tree().paused = false
	SignalBus.emit_signal("sceneTransition", "res://Game Scenes/bettertestlevel.tscn")
	await get_tree().create_timer(1).timeout
	get_tree().paused = true

func debug_text_toggle():
	debugOn = !debugOn
	if debugOn:
		updateDebug()
		debugUpdateTimer.start()
		debugText.show()
	else:
		debugText.hide()
		debugUpdateTimer.stop()
		
func FishTest():
	var FishingManager = $Menus/DebugMenu/FishTest/FishingManager
	var equipment = 1 # will be an actual value between 0 and sqrt(10) for actual fishing
	FishingManager.fishingGame(equipment)
	FishingManager.viewInventory()

#called from timer to update debug menu on timeout
func updateDebug():
	var s = "X-Speed: " + str(playerData[0]) + "\n" + "Y-Speed: " + str(playerData[1]) + "\n" + "Health: " + str(PlayerVariables.health) + "\n" + "Money: " + str(PlayerVariables.money) + "\n"
	debugText.set_text(s)
	
#to be used for debug menu
func updatePlayerData(dataArray):
	playerData = [dataArray[0], dataArray[1]]
