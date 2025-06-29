extends Node2D

@export var mob_scene: PackedScene
@export var area: Node

var player

func _ready() -> void:
	player = %MainPlayerChar

func _on_mob_timer_timeout():
	self.global_position.y = player.global_position.y - 256
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location using global coordinates.
	mob.global_position = mob_spawn_location.global_position

	# Spawn the mob by adding it to the Main scene.
	area.add_child(mob)
