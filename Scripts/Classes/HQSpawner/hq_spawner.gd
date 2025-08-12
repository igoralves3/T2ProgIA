extends Marker2D

var enemy_spawner

func _ready() -> void:
	await get_tree().get_frame()
	enemy_spawner = get_tree().get_first_node_in_group("Enemy_spawner")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_spawner.array_spawners.append(self)
	enemy_spawner.usando_outro_spawner = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enemy_spawner.array_spawners.erase(self)
	enemy_spawner.usando_outro_spawner = false
