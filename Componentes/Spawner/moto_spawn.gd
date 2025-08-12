extends Node2D

@export var moto_scene: PackedScene

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var moto = moto_scene.instantiate()
	moto.global_position = Vector2(global_position.x + 40,global_position.y)
	get_parent().add_child(moto)
