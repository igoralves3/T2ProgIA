extends Area2D


func _on_area_entered(area: Area2D) -> void:
	GameManager.setCheckPoint($Marker2D.global_position)
	print("checkpoint")
	queue_free()
