extends Area2D

#class_name Bullet

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.3 # acredito ser esse o valor real do jogo original
const SPEED = 750#317 # calculando que a bala anda 135 pixels no jogo antes de sumir, esse é pra ser o valor real
var tempo_animacao: float = 0.24
signal die
var is_moving = true
@onready var animation = $Sprite2D

func _ready():
	is_moving=true
	%TimerEnemy.wait_time = tempo_para_sumir
	%TimerEnemy.start()
	animation.frame = 0
	animation.stop()
	print('enemy bullet')

func _physics_process(delta: float) -> void:
	
		position += motion * SPEED * delta
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	print('bala inimiga saiu')
	queue_free()


func _on_timer_timeout() -> void:
	print('bala inimiga acabou')
	#is_moving = false
	animation.play("bullet")
	#await get_tree().create_timer(tempo_animacao).timeout
#	await get_tree().process_frame
	queue_free()
