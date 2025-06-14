extends CharacterBody2D

class_name Bullet

@export var motion := Vector2(0,0)

const SPEED = 600.0

func _ready():
#	print('bullet')
	pass

func _physics_process(delta: float) -> void:
	position += motion * SPEED * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
