extends Area2D

class_name GranadaExtra


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('coletou granada')
		body.grenadeAmmo =body.grenadeAmmo + 1
		print('granadas: '+str(body.grenadeAmmo))
		queue_free()
	else:
		print('nao coletou')
