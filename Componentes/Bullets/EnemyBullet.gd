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
	#print('enemy bullet')

func _physics_process(delta: float) -> void:
	if is_moving:
		position += motion * SPEED * delta
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	#print('bala inimiga saiu')
	queue_free()


func _on_timer_timeout() -> void:
	set_collision_mask_value(2, false)
	#print('bala inimiga acabou')
	is_moving = false
	animation.play("bullet")
	#await get_tree().create_timer(tempo_animacao).timeout
#	await get_tree().process_frame
	await animation.animation_finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
#	print ("enemybullet entered")
	set_collision_mask_value(2, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
#	print (body, "player bullet hit")
	if body.has_method("death_normal"):
		body.death_normal()
	await get_tree().create_timer(tempo_animacao).timeout
	queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	#print ("enemybullet entered AREA2D")
	set_collision_mask_value(2, false) #tirar colisao inimigo
	die.emit()
	is_moving = false
	animation.play("bullet")
	#print (area, "player bullet hit")
	if area.get_parent().has_method("death_normal"):
		area.get_parent().death_normal()
	await get_tree().create_timer(tempo_animacao).timeout
	queue_free()
