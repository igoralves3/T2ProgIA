extends Node2D

@export var infantaria: PackedScene
@export var granadeiro: PackedScene
@export var bazuca: PackedScene
@export var limite_de_inimigos: int = 4
@export var podeSpawnar: bool = true
var area: Node
var qual_area:= ""
var ListaInimigos: Array
var HUD
var player
var inimigo_atual:= ""
var max_bazucas: int = 4
var usando_outro_spawner: bool = false
var spawner_localizacao
var array_spawners: Array

func _ready() -> void:
	inimigo_atual = "infantaria"
	player = %MainPlayerChar
	get_HUD()
	if not GameManager.currentScene == "res://Cenas/Area_1.tscn":
		limite_de_inimigos = 5

func _on_mob_timer_timeout():
	if podeSpawnar:
		self.global_position.y = player.global_position.y - 256
		# Create a new instance of the Mob scene.
		if ListaInimigos.size() < limite_de_inimigos:
			var mob
			if inimigo_atual == "infantaria":
				mob = infantaria.instantiate()
			if inimigo_atual == "granadeiro":
				mob = granadeiro.instantiate()
			if inimigo_atual == "bazuca":
				max_bazucas = max_bazucas - 1
				mob = bazuca.instantiate()
				if max_bazucas <= 0:
					inimigo_atual = "infantaria"
			if not usando_outro_spawner:
				var mob_spawn_location = $MobPath/MobSpawnLocation
				mob_spawn_location.progress_ratio = randf()
				mob.global_position = mob_spawn_location.global_position
			if usando_outro_spawner:
				get_random_spawn()
				mob.global_position = spawner_localizacao.global_position
			mob.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
			ListaInimigos.append(mob)
			owner.add_child(mob)
			var collision = mob.move_and_collide(Vector2.ZERO)
			if collision:
				print('mob on collision')
				owner.remove_child(mob)
				_on_mob_timer_timeout()

func _on_mob_dead_enemy(enemy, pontos):
	if enemy in ListaInimigos:
#		GameManager.addPoints(pontos)
		ListaInimigos.erase(enemy)
	for inimigo in ListaInimigos:
		if inimigo == null:
			ListaInimigos.erase(inimigo)

func connect_dead_enemy(enemy):
	enemy.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
	ListaInimigos.append(enemy)

func _on_trigger_area_entered(area: Area2D) -> void:
	podeSpawnar = false
#	print("pode spawnar?", podeSpawnar)

func get_HUD():
	var HUD1 = get_tree().get_nodes_in_group("HUD")
	if not HUD1.is_empty():
		HUD = HUD1[0]

func trocar_para_infantaria():
	inimigo_atual = "infantaria"

func trocar_para_granadeiro():
	inimigo_atual = "granadeiro"

func trocar_para_bazuca():
	inimigo_atual = "bazuca"

func _on_trigger_body_entered(body):
	if body == %MainPlayerChar:
		podeSpawnar = false

func get_random_spawn():
	if array_spawners == null:
		usando_outro_spawner = false
		return
	elif array_spawners.size() == 0:
		usando_outro_spawner = false
		return
	var quantidade_de_spawners = 1 + array_spawners.size()
	print (quantidade_de_spawners)
	if randi_range(1,quantidade_de_spawners) == 1:
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		spawner_localizacao = mob_spawn_location
	else:
		spawner_localizacao = array_spawners.pick_random()
