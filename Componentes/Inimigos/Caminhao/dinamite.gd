extends Area2D

class_name Dinamite

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.7
const SPEED = 100 # calculando que a bala anda 95 pixels no jogo antes de sumir, esse é pra ser o valor real
@onready var animation = $Sprite2D
@export var explosao: PackedScene

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()

func _physics_process(delta: float) -> void:
	position += motion * SPEED * delta

func _on_timer_timeout() -> void:
	gera_explosao()
	queue_free()

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.position = position
	get_parent().add_child(explosao_instance)
