extends Area2D

class_name PlayerBullet

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.3 # acredito ser esse o valor real do jogo original
const SPEED = 317 # calculando que a bala anda 95 pixels no jogo antes de sumir, esse é pra ser o valor real
var tempo_animacao: float = 0.24
signal die #remove numero de bullets da tela
var is_moving = true
@onready var animation = $Sprite2D

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	animation.frame = 0
	animation.stop()

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
	get_tree().create_timer(tempo_animacao).timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	set_collision_mask_value(3, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	set_collision_mask_value(3, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	if body.has_method("bullet_hit"):
		body.bullet_hit()
	get_tree().create_timer(tempo_animacao).timeout.connect(queue_free)

func _on_area_entered(area: Area2D) -> void:
	set_collision_mask_value(3, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	if area.get_parent().has_method("bullet_hit"):
		area.get_parent().bullet_hit()
	get_tree().create_timer(tempo_animacao).timeout.connect(queue_free)
