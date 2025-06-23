extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var posicao = global_position
	body.death_pitfall(posicao)
	print ("caiu, morreu, rip")
