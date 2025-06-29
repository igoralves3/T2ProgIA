extends Node2D

var ListaInimigos: Array
var Enemy_spawner: Array
var Active_spawners: Array
var timer_de_spawn: Timer
var tempo_entre_spawns: float = 1
var timer_de_tiro: Timer
var tempo_entre_tiros: float = 1
var limite_de_inimigos: int = 4

func _ready() -> void:
	Enemy_spawner = get_tree().get_nodes_in_group("Enemy_spawner")
	timer_de_spawn = Timer.new()
	timer_de_spawn.wait_time = tempo_entre_spawns
	timer_de_spawn.timeout.connect(timer_de_spawn_end)
	add_child(timer_de_spawn)
	timer_de_spawn.start()
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

func get_active_spawners():
	
	Active_spawners.clear()
	for spawner in Enemy_spawner:
		if spawner.is_active:
			Active_spawners.append(spawner)

func timer_de_spawn_end():
	get_active_spawners()
	var spawner = Active_spawners.pick_random()
	if spawner.is_active:
		spawner.spawn_enemy()

func timer_de_tiro_end():
	meter_bala()
