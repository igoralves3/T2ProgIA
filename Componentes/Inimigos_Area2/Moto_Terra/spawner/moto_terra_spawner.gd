extends Area2D

@export var moto_terra : PackedScene

func _on_area_entered(area: Area2D) -> void:
	var moto = moto_terra.instantiate()
	moto.global_position = global_position
	get_parent().add_child(moto)
	queue_free()
