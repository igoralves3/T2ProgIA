extends Area2D


func _on_area_entered(area: Area2D) -> void:
	GameManager.setCheckPoint($Marker2D.position)
	GameManager.hasCheckpoint = true
	print("checkpoint")
	queue_free()
