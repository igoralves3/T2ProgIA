extends Node2D

@export var infantaria: PackedScene
@export var granadeiro: PackedScene
@export var bazuca: PackedScene
@export var general: PackedScene
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
var Inimigos_fortress: int = 15
var spawned_general: bool = false
var avisou_ending: bool = false

func _ready() -> void:
	inimigo_atual = "infantaria"
	player = %MainPlayerChar
	get_HUD()
	if not GameManager.currentScene == "res://Cenas/Area_1.tscn":
		limite_de_inimigos = 5

func _on_mob_timer_timeout():
	if podeSpawnar:
		self.global_position.y = player.global_position.y - 256
		if ListaInimigos.size() < limite_de_inimigos:
			get_random_spawn()
			var mob
			if inimigo_atual == "infantaria":
				mob = infantaria.instantiate()
			if inimigo_atual == "granadeiro":
				mob = granadeiro.instantiate()
			if inimigo_atual == "bazuca":
				if max_bazucas <= 0:
					inimigo_atual = "infantaria"
					return
				else:
					max_bazucas = max_bazucas - 1
					mob = bazuca.instantiate()
			if not usando_outro_spawner:
				var mob_spawn_location = $MobPath/MobSpawnLocation
				mob_spawn_location.progress_ratio = randf()
				mob.global_position = mob_spawn_location.global_position
			if usando_outro_spawner:
				get_random_spawn()
				if spawner_localizacao is Toca and inimigo_atual == "infantaria":
					mob = mexer_no_mob(mob)
				mob.global_position = spawner_localizacao.global_position
			mob.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
			ListaInimigos.append(mob)
			owner.add_child(mob)
			var collision = mob.move_and_collide(Vector2.ZERO)
			if collision:
				print ("colisao spawn")
				if inimigo_atual == "bazuca":
					max_bazucas = max_bazucas + 1
				owner.remove_child(mob)
				_on_mob_timer_timeout()

func _on_mob_dead_enemy(enemy, _pontos):
	if enemy in ListaInimigos:
#		GameManager.addPoints(pontos)
		ListaInimigos.erase(enemy)
	for inimigo in ListaInimigos:
		if inimigo == null:
			ListaInimigos.erase(inimigo)
		elif not is_instance_valid(inimigo):
			ListaInimigos.erase(inimigo)
		elif (player.global_position - inimigo.global_position).length() > 350:
			inimigo.queue_free()
			ListaInimigos.erase(enemy)
		elif not inimigo.is_inside_tree():
			ListaInimigos.erase(inimigo)
			inimigo.queue_free()
	if array_spawners != null:
		if array_spawners.size() > 0:
			for spawner in array_spawners:
				if (player.global_position - spawner.global_position).length() > 450:
					array_spawners.erase(spawner)

func connect_dead_enemy(enemy):
	enemy.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
	ListaInimigos.append(enemy)

func _on_trigger_area_entered(_area: Area2D) -> void:
	podeSpawnar = false

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
		#start_fortress()
		podeSpawnar = false

func get_random_spawn():
	if array_spawners == null:
		usando_outro_spawner = false
		return
	elif array_spawners.size() == 0:
		usando_outro_spawner = false
		return
	var quantidade_de_spawners = 1 + array_spawners.size()
	if randi_range(1,quantidade_de_spawners) == 1:
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		spawner_localizacao = mob_spawn_location
	else:
		spawner_localizacao = array_spawners.pick_random()

func mexer_no_mob(mob):
	if inimigo_atual == "infantaria":
		mob.FSM.initial_state = mob.FSM.get_node("Straight")
		mob.FSM.current_state = mob.FSM.get_node("Straight")
		mob.FSM.current_state.move_direction = spawner_localizacao.move_direction
		mob.FSM.current_state.enter()
#	print (mob.FSM.current_state, " state ", mob.FSM.current_state.move_direction, " current direction" )
	return mob

func start_fortress():
	print ("start fortress")
	$MobTimer.stop()
	$Fortress_timer.start()
	inimigo_atual = "infantaria"
	limite_de_inimigos = 8
	var lista_morteiros = get_tree().get_nodes_in_group("Morteiros")
	if lista_morteiros != null:
		if lista_morteiros.size() > 0:
			for morteiro in lista_morteiros:
				ListaInimigos.append(morteiro)

func _on_fortress_timer_timeout() -> void:
	if get_parent().qual_stage == "Area_2":
		area_2_fortress()
	else:
		area_1_e_3_fortress()

func area_2_fortress():
	spawner_localizacao = array_spawners.pick_random()
	if ListaInimigos.size() < limite_de_inimigos:
		if Inimigos_fortress > 0:
			Inimigos_fortress = Inimigos_fortress - 1
			var mob
			if not spawned_general and randi_range(1,5) > 4:
				mob = general.instantiate()
				spawned_general = true
			else:
				mob = infantaria.instantiate()
				mob = mexer_no_mob(mob)
			mob.global_position = spawner_localizacao.global_position
#			print (mob.global_position)
			mob.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
			ListaInimigos.append(mob)
			owner.add_child(mob)
			var collision = mob.move_and_collide(Vector2.ZERO)
			print (mob)
			if collision:
				print (mob, " colisao + inimigos fotress ", Inimigos_fortress, " limite_de_inimigos ", limite_de_inimigos)
				Inimigos_fortress = Inimigos_fortress + 1
				owner.remove_child(mob)
				_on_mob_timer_timeout()
	if ListaInimigos.size() == 0 and Inimigos_fortress == 0:
		if not avisou_ending:
			avisou_ending = true
			get_parent().next_level()

func area_1_e_3_fortress():
	spawner_localizacao = array_spawners.pick_random()
	if ListaInimigos.size() < limite_de_inimigos:
		if Inimigos_fortress > 0:
			Inimigos_fortress = Inimigos_fortress - 1
			var mob
			if not spawned_general and randi_range(1,5) > 1:
				mob = general.instantiate()
				spawned_general = true
			else:
				mob = infantaria.instantiate()
				mob = mexer_no_mob_baixo(mob)
			mob.global_position = spawner_localizacao.global_position + Vector2(randf_range(-10,10),-120)
#			print (mob.global_position)
			mob.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
			ListaInimigos.append(mob)
			owner.add_child(mob)
			var collision = mob.move_and_collide(Vector2.ZERO)
			if collision:
				Inimigos_fortress = Inimigos_fortress + 1
				owner.remove_child(mob)
				_on_mob_timer_timeout()
	if ListaInimigos.size() == 0 and Inimigos_fortress == 0:
		if not avisou_ending:
			avisou_ending = true
			get_parent().next_level()

func mexer_no_mob_baixo(mob):
#	print ("final mob spawn")
	mob.FSM.initial_state = mob.FSM.get_node("Straight")
	mob.FSM.current_state = mob.FSM.get_node("Straight")
	mob.FSM.current_state.move_direction = randf_range(-0.3,0.3)
	mob.FSM.current_state.move_speed = 100
	mob.FSM.current_state.wander_time = randf_range(2,3)
	mob.FSM.current_state.enter()
	return mob

func _on_trigger_limitador_enemy_spawn_body_entered(_body: Player) -> void: #Trigger da Area_1, limita inimigos + spawna granadeiros
	limite_de_inimigos = 2
	inimigo_atual = "granadeiro"

func _on_orphan_clean_timer_timeout() -> void:
	for inimigo_da_lista in ListaInimigos:
		if inimigo_da_lista == null:
			ListaInimigos.erase(inimigo_da_lista)
		elif not inimigo_da_lista.is_inside_tree():
			ListaInimigos.erase(inimigo_da_lista)
