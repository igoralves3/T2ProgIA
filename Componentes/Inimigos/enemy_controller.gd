extends Node2D

var ListaInimigosBullet: Array
var ListaInimigosGranada: Array
var timer_de_tiro: Timer
var timer_de_granada: Timer
var timer_update_granadeiros
var tempo_entre_tiros: float = 1
var tempo_entre_granadas: float = 1
var granadas_voando: int = 0
var granadeiros_em_cooldown: Array
var cooldown_granadas: bool = false
var tempo_cooldown: float = 0.1
var qual_area:= ""

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
	timer_update_granadeiros = Timer.new()
	timer_update_granadeiros.wait_time = tempo_cooldown
	timer_update_granadeiros.timeout.connect(timer_update_granadeiros_end)
	add_child(timer_update_granadeiros)
	timer_update_granadeiros.start()
	if not GameManager.currentScene == "res://Cenas/Area_1.tscn":
		tempo_entre_tiros = 0.5
		
	


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

func update_granadas(valor): #funcao exclusiva para infantaria granadeira
	granadas_voando = granadas_voando + valor
	if granadas_voando > 4 or cooldown_granadas:
		var ListaGranada = get_tree().get_nodes_in_group("InimigosSoGranadeiros")
		for inimigo in ListaGranada:
			if inimigo.pode_atirar_granada == true:
				granadeiros_em_cooldown.append(inimigo)
				inimigo.pode_atirar_granada = false

func timer_update_granadeiros_end():
	if granadas_voando < 4:
		for inimigo in granadeiros_em_cooldown:
			inimigo.pode_atirar_granada = true
		granadeiros_em_cooldown.clear()
