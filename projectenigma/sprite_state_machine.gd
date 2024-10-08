extends Node


@onready var parent: CharacterBody2D = get_parent()
# Called when the node enters the scene tree for the first time.
func run_state(delta):
	parent.player_input()
	parent.aim(parent.get_global_mouse_position())
	
