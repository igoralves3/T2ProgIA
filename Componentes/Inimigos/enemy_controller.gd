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
	var inimigo = ListaInimigos.pick_random()
	if inimigo.can_shoot:
		inimigo.fire_bullet()
	#else:

<<<<<<< Updated upstream
=======
func get_active_spawners():
	
	Active_spawners.clear()
	for spawner in Enemy_spawner:
		if spawner.is_active:
			Active_spawners.append(spawner)

func timer_de_spawn_end():
	if get_tree().get_nodes_in_group("Inimigos").size() < 5:
		get_active_spawners()
		var spawner = Active_spawners.pick_random()
		if spawner.is_active:
			spawner.spawn_enemy()

>>>>>>> Stashed changes
func timer_de_tiro_end():
	meter_bala()
