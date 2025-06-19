extends CharacterBody2D

class_name Bullet

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.3 # acredito ser esse o valor real do jogo original
const SPEED = 317 # calculando que a bala anda 95 pixels no jogo antes de sumir, esse é pra ser o valor real
signal die

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
#	print('bullet')
	pass

func _physics_process(delta: float) -> void:
	position += motion * SPEED * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die.emit()
	queue_free()


func _on_timer_timeout() -> void:
	die.emit()
#	await get_tree().process_frame
	queue_free()
