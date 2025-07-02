extends Node

@export var initial_state: State

var states: Dictionary = {}
var current_state
var label_state: Label

func _ready():
	label_state = get_parent().get_node("LabelState")
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		label_state.text = current_state.name.to_lower()
	
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	#print("MUDANDO DE ESTADO!")
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	if label_state:
		label_state.text = new_state_name
