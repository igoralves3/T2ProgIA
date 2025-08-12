extends Area2D

const SPEED := 100
@export var dir:= Vector2.ZERO
@export var explosao: PackedScene

func _physics_process(delta: float) -> void:
	position = position + dir *SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("death_normal"):
		body.death_normal()
	gera_explosao()
	queue_free()

func _on_timer_queue_free_timeout() -> void:
	gera_explosao()
	queue_free()

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.position = position
	get_parent().call_deferred("add_child", explosao_instance)
#	add_child(explosao_instance)
