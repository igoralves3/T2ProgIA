extends Node2D

var ListaInimigosBullet: Array
var ListaInimigosGranada: Array
var timer_de_tiro: Timer
var timer_de_granada: Timer
var tempo_entre_tiros: float = 1
var tempo_entre_granadas: float = 1

func _ready() -> void:
	timer_de_tiro = Timer.new()
	timer_de_tiro.wait_time = tempo_entre_tiros
	timer_de_tiro.timeout.connect(timer_de_tiro_end)
	add_child(timer_de_tiro)
	timer_de_tiro.start()
	timer_de_granada = Timer.new()
	timer_de_granada.wait_time = tempo_entre_granadas
	timer_de_granada.timeout.connect(timer_de_granada_end)
	add_child(timer_de_granada)
	timer_de_granada.start()


func meter_bala():
	ListaInimigosBullet = get_tree().get_nodes_in_group("Inimigos")
	var AtiradoresAtivos: Array
	for inimigo in ListaInimigosBullet:
		if inimigo.can_shoot == true:
			AtiradoresAtivos.append(inimigo)
	if AtiradoresAtivos.size()>0:
		var inimigo = AtiradoresAtivos.pick_random()
		inimigo.fire_bullet()

func meter_granada():
	ListaInimigosGranada = get_tree().get_nodes_in_group("InimigosGranadas")
	var GranadeirosAtivos: Array
	for inimigo in ListaInimigosGranada:
		if inimigo.pode_atirar_granada == true:
			GranadeirosAtivos.append(inimigo)
	if GranadeirosAtivos.size()>0:
		var inimigo = GranadeirosAtivos.pick_random()
		inimigo.fire_grenade()

func timer_de_tiro_end():
	meter_bala()

func timer_de_granada_end():
	meter_granada()
