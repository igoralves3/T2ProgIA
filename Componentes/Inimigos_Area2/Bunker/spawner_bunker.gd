extends Node2D

@export var infantaria: PackedScene
@export var other_player: PackedScene
var can_spawn = false

func _ready():
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	can_spawn=true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	can_spawn = false


func _on_timer_timeout() -> void:
	if can_spawn:
		var instance = infantaria.instantiate()
	
		instance.position = position
		get_parent().add_child(instance)
