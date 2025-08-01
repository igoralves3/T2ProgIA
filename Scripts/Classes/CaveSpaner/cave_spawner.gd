extends Node

@export var enemyCount = 15
@export var general: PackedScene
@export var infantaria: PackedScene
var listaDeMarkers: Array
var canSpawn:= false
var spawn_timer: Timer
var spawn_delay := 1 # You may want to adjust this value or export it

func _ready():
	listaDeMarkers = get_tree().get_nodes_in_group("SpawnMarkers")

func pickRandomMarker() -> Node:
	if listaDeMarkers.size() == 0:
		return null
	var random_index = randi() % listaDeMarkers.size()
	return listaDeMarkers[random_index]

func spawn_enemies():
	print_stack()
	if enemyCount <= 0:
		spawn_timer.stop()
		print_debug("No enemies to spawn.")
		return
	print_debug("Spawning enemies, count: ", enemyCount)

func _spawn_single_enemy(type: String):

	if not infantaria or not general:
		return

	var marker = pickRandomMarker()
	if not marker:
		return

	var enemy
	if type == "general":
		enemy = general.instantiate()
	else:
		enemy = infantaria.instantiate()

	enemy.add_to_group("finalStageEnemies")
	enemy.global_position = marker.global_position
	get_tree().current_scene.add_child(enemy)

func _on_spawn_timer_timeout():
	if enemyCount <= 0:
		spawn_timer.stop()
		return

	var marker = pickRandomMarker()
	if not marker:
		print_debug("No valid spawn marker found.")
		return
	_spawn_single_enemy("general" if enemyCount == 1 else "infantaria")
	
	enemyCount -= 1
	if enemyCount <= 0:
		spawn_timer.stop()

func _on_trigger_body_entered(body):
	if not(body == %MainPlayerChar):
		return
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_delay
	spawn_timer.one_shot = false # We want it to keep ticking until we stop it
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()
	spawn_enemies()
