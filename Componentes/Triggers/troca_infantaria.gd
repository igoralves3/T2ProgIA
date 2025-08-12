extends Area2D

@export_enum("Infantaria","Granadeiro","Bazuca") var inimigo: String

func _on_body_entered(_body: Player) -> void:
	var enemy_spawner = get_tree().get_first_node_in_group("Enemy_spawner")
	if inimigo == "Infantaria":
		enemy_spawner.trocar_para_infantaria()
	if inimigo == "Granadeiro":
		enemy_spawner.trocar_para_granadeiro()
	if inimigo == "Bazuca":
		enemy_spawner.trocar_para_bazuca()
	queue_free()
