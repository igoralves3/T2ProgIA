extends Area2D


func _on_body_entered(_body: Player) -> void:
	queue_free()
