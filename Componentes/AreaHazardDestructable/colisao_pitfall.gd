extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var posicao = global_position
	if body.has_method("death_pitfall"):
		body.death_pitfall(posicao)
