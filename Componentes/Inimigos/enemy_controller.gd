extends Node2D

var ListaInimigos: Array
var timer_de_tiro: Timer
var tempo_entre_tiros: float = 1

func _ready() -> void:
	timer_de_tiro = Timer.new()
	timer_de_tiro.wait_time = tempo_entre_tiros
	timer_de_tiro.timeout.connect(timer_de_tiro_end)
	add_child(timer_de_tiro)
	timer_de_tiro.start()

func meter_bala():
	ListaInimigos = get_tree().get_nodes_in_group("Inimigos")
	if ListaInimigos.size()>0:
		var inimigo = ListaInimigos.pick_random()
		if inimigo.can_shoot:
			inimigo.fire_bullet()
	#else:

func timer_de_tiro_end():
	meter_bala()
