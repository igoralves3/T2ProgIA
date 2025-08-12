extends Node2D
class_name Toca

#@export var infantaria: PackedScene
#@export var other_player: PackedScene
#var can_spawn = false
var enemy_spawner
@export var move_direction: float = -1
@export var fortress: bool = false

func _ready() -> void:
	await get_tree().get_frame()
	enemy_spawner = get_tree().get_first_node_in_group("Enemy_spawner")
#	enemy_spawner.array_spawners.append(self)
#	enemy_spawner.usando_outro_spawner = true



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_spawner.array_spawners.append(self)
	if not fortress:
		enemy_spawner.usando_outro_spawner = true



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enemy_spawner.array_spawners.erase(self)
