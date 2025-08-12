extends Node2D

@export var jeep : PackedScene
var other_player: CharacterBody2D

func _ready():
	other_player = %MainPlayerChar

func _on_area_entered(_area: Area2D) -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	var offset_spawn = -70
	if other_player.global_position.x - 70 < 0:
		offset_spawn = + 150
	var jeep_instance = jeep.instantiate()
	jeep_instance.global_position = Vector2(other_player.global_position.x + offset_spawn, global_position.y)
	get_parent().add_child(jeep_instance)
	queue_free()

func _on_spawn_trigger_body_entered(_body: Node2D) -> void:
	var mob = jeep.instantiate()
	var mob_spawn_location = $JeepPath/JeepSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location using global coordinates.
	mob.global_position = mob_spawn_location.global_position
	get_parent().add_child(mob)
	queue_free()
