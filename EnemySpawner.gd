extends Node2D

@export var mob_scene: PackedScene
@export var limite_de_inimigos: int = 4
var podeSpawnar: bool = true
@export var area: Node

var ListaInimigos: Array

var player

func _ready() -> void:
	player = %MainPlayerChar

func _on_mob_timer_timeout():
	if podeSpawnar:
		self.global_position.y = player.global_position.y - 256
		# Create a new instance of the Mob scene.
		if ListaInimigos.size() < limite_de_inimigos:
			var mob = mob_scene.instantiate()
	
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
			area.add_child(mob)
		
			var collision = mob.move_and_collide(Vector2.ZERO)
			if collision:
				print('mob on collision')
				area.remove_child(mob)

func _on_mob_dead_enemy(enemy):
	# Handle the enemy death here (e.g., remove from list, spawn more, etc.)
	if enemy in ListaInimigos:
		GameManager.addPoints(enemy.pontos)
		ListaInimigos.erase(enemy)
	# Optionally, queue_free the enemy if not already done
	# enemy.queue_free()


func _on_trigger_area_entered(area: Area2D) -> void:
	podeSpawnar = !podeSpawnar
	print("pode spawnar?", podeSpawnar)
