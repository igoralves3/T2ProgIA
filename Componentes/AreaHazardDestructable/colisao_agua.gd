extends Area2D

var posicao: Vector2

func _on_body_entered(body: Node2D) -> void:
	var posicao = self.global_position
	if body.has_method("death_water"):
		body.death_water(posicao)
