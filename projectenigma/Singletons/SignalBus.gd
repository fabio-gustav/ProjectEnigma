extends Node

signal display_dialog(text_key)

#for the debug screen to connect with the player
signal debugData(playerDataArray)

#called to move to a new scene with scene_transtion and a fade to black, level is the filepath of the scene you want to transition to
signal sceneTransition(level)

#to be called both before and after a scene starts and ends loading to know when to fade to black and back out
signal loading()

#returns the player's current velocity
signal playerVelocity(velocity)

#called when diolog is finished playing
signal dialog_finished()

signal health_changed()

#called whenever you money is changed
signal money_changed()
