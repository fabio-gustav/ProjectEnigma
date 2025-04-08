extends Node

class_name State

signal Transitioned

@onready var player: CharacterBody2D = get_parent().get_parent()
@onready var legs: AnimatedSprite2D = %Legs
@onready var arm: AnimatedSprite2D = %Arm



func enter():
	pass
	
func exit():
	pass
	
func update(_delta:float):
	pass
	
func physicsUpdate(_delta:float):
	pass
	

func get_input() -> float:
	var input_direction = Input.get_axis("left","right")
	return input_direction
