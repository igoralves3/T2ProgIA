extends Node2D

var ListaInimigos: Array

func meter_bala():

	ListaInimigos = get_tree().get_nodes_in_group("Inimigos")
	var inimigo = ListaInimigos.pick_random()
	if inimigo.can_shoot:
		inimigo.fire_bullet()
	#else:
		
