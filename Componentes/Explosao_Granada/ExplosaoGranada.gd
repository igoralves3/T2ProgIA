extends Area2D


var tempo_para_sumir: float = 1.0

@export var dono: CharacterBody2D

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	print('explosao')	


func _on_timer_timeout() -> void:
	print('fim explosao')
	queue_free()
