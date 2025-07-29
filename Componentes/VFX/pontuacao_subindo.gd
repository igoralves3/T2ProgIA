extends AnimatedSprite2D

var dono: String
@export var timer_sumir: Timer


func _ready() -> void:
	if dono == "Prisioneiro":
		play("1000")
	if dono == "General":
		play("2000")
		timer_sumir.wait_time = 0.5
	timer_sumir.start()


func _on_tempo_para_sumir_timeout() -> void:
	queue_free()
