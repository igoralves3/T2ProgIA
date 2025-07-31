extends Node2D

@export var infantaria: PackedScene
@export var granadeiro: PackedScene
@export var limite_de_inimigos: int = 4
@export var podeSpawnar: bool = true
var area: Node

var ListaInimigos: Array
var HUD
var player

func _ready() -> void:
	player = %MainPlayerChar
	get_HUD()

func _on_mob_timer_timeout():
	if podeSpawnar:
		self.global_position.y = player.global_position.y - 256
		# Create a new instance of the Mob scene.
		if ListaInimigos.size() < limite_de_inimigos:
			var mob = infantaria.instantiate() # infantaria.instantiate()
	
			# Choose a random location on Path2D.
			var mob_spawn_location = $MobPath/MobSpawnLocation
			mob_spawn_location.progress_ratio = randf()
	
			# Set the mob's position to the random location using global coordinates.
			mob.global_position = mob_spawn_location.global_position


			#var overlaps_areas = mob.area_colisao_morte.get_overlapping_areas()
	
	
			#if overlaps_areas.size() > 0:
			#	return

			#var overlaps_collision = mob.area_colisao_morte.get_overlapping_bodies()
	
	
			#if overlaps_collision.size() > 0:
				#return


			# Connect dead_enemy signal
			mob.connect("dead_enemy", Callable(self, "_on_mob_dead_enemy"))
			ListaInimigos.append(mob)

			# Spawn the mob by adding it to the Main scene.
			owner.add_child(mob)
		
			var collision = mob.move_and_collide(Vector2.ZERO)
			if collision:
				print('mob on collision')
				owner.remove_child(mob)

func _on_mob_dead_enemy(enemy, pontos):
	# Handle the enemy death here (e.g., remove from list, spawn more, etc.)
	if enemy in ListaInimigos:
#		GameManager.addPoints(pontos)
		ListaInimigos.erase(enemy)
#		if HUD != null:
#			HUD.single_update()
#		else:
#			get_HUD()
#			HUD.single_update()
	# Optionally, queue_free the enemy if not already done
	# enemy.queue_free()


func _on_trigger_area_entered(area: Area2D) -> void:
	podeSpawnar = false
	print("pode spawnar?", podeSpawnar)

func get_HUD():
	var HUD1 = get_tree().get_nodes_in_group("HUD")
	if not HUD1.is_empty():
		HUD = HUD1[0]
