extends Area2D


func _on_area_entered(_area: Area2D) -> void:
	GameManager.setCheckPoint($Marker2D.global_position)
	queue_free()
