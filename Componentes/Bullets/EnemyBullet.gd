extends Area2D

#class_name Bullet

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 1.92 # acredito ser esse o valor real do jogo original
var SPEED = 70#317 # calculando que a bala anda 135 pixels no jogo antes de sumir, esse é pra ser o valor real
var tempo_animacao: float = 0.24
signal die #remove numero de bullets da tela
var is_moving = true
@onready var animation = $Sprite2D

func _ready():
	is_moving=true
	%TimerEnemy.wait_time = tempo_para_sumir
	%TimerEnemy.start()
	animation.frame = 0
	animation.stop()

func _physics_process(delta: float) -> void:
	if is_moving:
		position += motion * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	set_collision_mask_value(2, false)
	is_moving = false
	animation.play("bullet")
	animation.animation_finished.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	set_collision_mask_value(2, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	if body.has_method("death_normal"):
		body.death_normal()
	get_tree().create_timer(tempo_animacao).timeout.connect(queue_free)

func _on_area_entered(area: Area2D) -> void:
	if area is Humvee:# or area is Turret:
		return
	set_collision_mask_value(2, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	if area.get_parent().has_method("death_normal"):
		area.get_parent().death_normal()
	get_tree().create_timer(tempo_animacao).timeout.connect(queue_free)
	queue_free()
