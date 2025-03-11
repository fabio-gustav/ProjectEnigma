extends Node

signal display_dialog(text_key)

#for the debug screen to connect with the player
signal debugData(playerDataArray)

#called to move to a new scene with scene_transtion and a fade to black, level is the filepath of the scene you want to transition to
signal sceneTransition(level)

#to be called both before and after a scene starts and ends loading to know when to fade to black and back out
signal loading()

signal playerVelocity(velocity)

signal health_changed()

#called whenever you money is changed
signal money_changed()
#Note: Definitley a better way to do this, but I'm too lazy rn to figure it out
#called to change your money
signal changeMoney(money : float)
