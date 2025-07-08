extends Area2D

class_name GranadaExtra

@export var grenadeBonus = 1

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('coletou granada')
		body.grenadeAmmo =body.grenadeAmmo + grenadeBonus
		print('granadas: '+str(body.grenadeAmmo))
		queue_free()
	else:
		print('nao coletou')
