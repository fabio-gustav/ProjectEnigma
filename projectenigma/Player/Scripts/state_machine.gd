extends Node2D


@export var intitialState : State


var states : Dictionary = {}
var currentState : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if intitialState:
		intitialState.enter()
		currentState = intitialState
		
func _process(delta: float) -> void:
	#print("Current State:" + currentState.to_string())
	if currentState:
		currentState.update(delta)

func _physics_process(delta: float) -> void:
	
			
	if currentState:
		currentState.physicsUpdate(delta)
	
		

func on_child_transition(state, new_state_name):
	#print("Transition from " + state + " to " + new_state_name)
	if state == currentState.name:
		print("help!")
		return
		
	var newState = states.get(new_state_name.to_lower())
	
	if !newState:
		print("help!")
		return

	
	newState.Enter()
	
	currentState = newState
	#print(currentState.name)
	
