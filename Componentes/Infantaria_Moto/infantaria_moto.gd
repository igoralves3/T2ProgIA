extends Area2D

const SPEED := 50


func _ready():
	print('moto pronta')

func _physics_process(delta: float) -> void:
	print('moto dentro')
	position.x = position.x -SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('moto fora')
	
	queue_free()
