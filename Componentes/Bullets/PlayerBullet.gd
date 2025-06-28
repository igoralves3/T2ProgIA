extends Area2D

#class_name Bullet

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.3 # acredito ser esse o valor real do jogo original
const SPEED = 317 # calculando que a bala anda 95 pixels no jogo antes de sumir, esse é pra ser o valor real
var tempo_animacao: float = 0.24
signal die
var is_moving = true
@onready var animation = $Sprite2D

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	animation.frame = 0
	animation.stop()
#	print('bullet')

func _physics_process(delta: float) -> void:
	if is_moving:
		position += motion * SPEED * delta
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die.emit()
	
	queue_free()


func _on_timer_timeout() -> void:
	die.emit()
	is_moving = false
	animation.play("bullet")
	await get_tree().create_timer(tempo_animacao).timeout
#	await get_tree().process_frame
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	die.emit()
	set_collision_mask_value(3, false) #tirar colisao inimigo
	is_moving = false
	animation.play("bullet")
	print (body, "player bullet hit")
	if body.has_method("bullet_hit"):
		body.bullet_hit()
	await get_tree().create_timer(tempo_animacao).timeout
	queue_free()
	
