extends Area2D

const SPEED := 100
@onready var _animated_sprite = $AnimatedSprite2D
@export var dir:= Vector2.ZERO
@export var explosao: PackedScene

func _ready():
	if dir.x < -0.2 and dir.x > -0.45:
		_animated_sprite.play('L1')
	elif dir.x < -0.45:
		_animated_sprite.play('L2')
	elif dir.x > 0.2 and dir.x < 0.45:
		_animated_sprite.play('D1')
	elif dir.x > 0.45:
		_animated_sprite.play('D2')
	else:
		_animated_sprite.play('reto')

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
