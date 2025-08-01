extends Marker2D

@onready var infantaria = preload("res://Componentes/Inimigos/Infantaria/infantaria.tscn")
var timer = Timer.new()
var enemy_spawner

func _ready() -> void:
	await get_tree().get_frame()
	enemy_spawner = get_tree().get_first_node_in_group("Enemy_spawner")
#	enemy_spawner.array_spawners.append(self)
#	enemy_spawner.usando_outro_spawner = true
	

#	timer.wait_time = 1.0
#	timer.one_shot = false
#	add_child(timer)
#	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

#func _on_timer_timeout():
#	var infantaria_instance = infantaria.instantiate()
#	infantaria_instance.global_position = self.global_position
#	get_tree().current_scene.add_child(infantaria_instance)
#
#
#func _on_hq_trigger_body_entered(body: Player) -> void:
#	enemy_spawner.array_spawners.append(self)
#	enemy_spawner.usando_outro_spawner = true
#	$"../HQTrigger".queue_free()
#
##	timer.start()
##
#func _on_checkpoint_3_area_entered(area: Player) -> void:
#	enemy_spawner.array_spawners.erase(self)
#	enemy_spawner.usando_outro_spawner = false

#	timer.stop()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_spawner.array_spawners.append(self)
	enemy_spawner.usando_outro_spawner = true
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enemy_spawner.array_spawners.erase(self)
	enemy_spawner.usando_outro_spawner = false
	pass # Replace with function body.
