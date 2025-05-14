class_name State
extends Node

@onready var parent: CharacterBody2D
@onready var legs: AnimatedSprite2D = %Legs
@onready var arm: AnimatedSprite2D = %Arm

var move_component

func init() -> void:
	pass

func enter() -> void:
	#parent.animations.play(animation_name)
	pass
	
func exit():
	pass
	
func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func get_movement_input() -> float:
	return move_component.get_movement_direction()
