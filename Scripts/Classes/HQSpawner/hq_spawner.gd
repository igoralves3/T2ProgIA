extends Marker2D

@onready var infantaria = preload("res://Componentes/Inimigos/Infantaria/infantaria.tscn")
var timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	var infantaria_instance = infantaria.instantiate()
	infantaria_instance.global_position = self.global_position
	get_tree().current_scene.add_child(infantaria_instance)


func _on_hq_trigger_body_entered(body: Node2D) -> void:
	timer.start()

func _on_checkpoint_3_area_entered(area: Area2D) -> void:
	timer.stop()
