extends Node2D

@export var infantaria: PackedScene
@export var other_player: PackedScene
var can_spawn = false


func _on_timer_timeout() -> void:
	if can_spawn:
		print('spawned')
		var instance = infantaria.instantiate()
	
		instance.position = position
		
		instance.FSM.initial_state = instance.FSM.get_node("Straight")
		instance.FSM.current_state = instance.FSM.get_node("Straight")
		if global_position.x > get_viewport_rect().size.x / 2:
			instance.FSM.current_state.move_direction = Vector2.LEFT
		else:
			instance.FSM.current_state.move_direction = Vector2.RIGHT
		instance.FSM.current_state.enter()
		
		get_parent().add_child(instance)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	can_spawn=true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	can_spawn = false
