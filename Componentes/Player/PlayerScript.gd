extends CharacterBody2D
class_name Player

var canShoot: bool = true

const SPEED = 68.0 # 3 segundos pra atravessar a tela da esquerda pra direita

@export var bullet :PackedScene
@export var grenade :PackedScene
@onready var _animated_sprite = $PlayerSprite
@onready var camera = %Camera2D

@onready var SFXShootBullet = $SFXShootBullet
@onready var SFXPlayerDeath = $SFXPlayerDeath

var tween: Tween

var bullets = []
var easy:= false
var delay_entre_tiros: float = 0.055 # é por ai
var cooldown_arma: float = 0.5 
var can_shoot := true
var can_throw_grenade := true
var is_shooting:= false
var quantidade_de_bullets_voando: int = 0 
var can_move: bool = true
var dir:= Vector2(0,1)
var tamanho_tela
var posicao_camera
var centro_tela


func _ready() -> void:
	await get_tree().process_frame
	tamanho_tela = get_viewport_rect().size

func _process(delta):
#	print (posicao_camera, "posicao camera")
#	print (tamanho_tela, "tamanho tela")
#	print (centro_tela, "centro tela")
#	print (camera.offset, "offset")
	centro_tela = tamanho_tela/2
	if camera != null:
		posicao_camera = camera.offset
		var min_x = posicao_camera.x +11
		var max_x = posicao_camera.x + tamanho_tela.x -11
		var min_y = posicao_camera.y - 500
		var max_y = posicao_camera.y + tamanho_tela.y - 18
		
		position.x = clamp(position.x, min_x, max_x)
		position.y = clamp(position.y, min_y, max_y)
	#print (self.motion)

func _physics_process(delta: float) -> void:
	#move_8_way(delta)
	get_8_way_input()
	move_and_slide()
	if velocity != Vector2.ZERO:
		dir = velocity.normalized()
	bullets = bullets.filter(func(bullet):
		return is_instance_valid(bullet) and bullet.get_parent() != null)
	#print(quantidade_de_bullets_voando)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"): #atira se não tiver 5 ou mais balas voando
		is_shooting = true
		burst_bullet()
	
	if event.is_action_released("Shoot"):
		is_shooting = false
	
	if event.is_action_pressed("Grenade"):
		spawn_grenade()

func update_animation(input_direction: Vector2) -> void:
	
	
	if input_direction.x > 0 and input_direction.y == 0:
		_animated_sprite.play("run_right")		
	elif input_direction.x < 0 and input_direction.y == 0:
		_animated_sprite.play("run_left")
	elif  input_direction.x == 0 and input_direction.y > 0:
		_animated_sprite.play("run_down")		
	elif input_direction.x == 0 and input_direction.y < 0:
		_animated_sprite.play("run_up")
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_right")		
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_left")
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_left")		
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_right")
	elif can_throw_grenade == false:
		_animated_sprite.play("throw_grenade")
		await get_tree().create_timer(0.3).timeout #tem que arrumar aqui, ta ruim a animacao
		_animated_sprite.stop()
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio

func get_8_way_input() -> void:
	var input_direction = Input.get_vector("Left","Right","Up","Down")
	if can_move:
		update_animation(input_direction)	
		velocity = input_direction * SPEED
	

#func move_8_way(delta: float) -> void:
#	get_8_way_input() # \/ será usado mais a frente
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info:
	#	var collision_point = collision_info.get_position()
		
	#	velocity = velocity.bounce(collision_info.get_normal())
	#	move_and_collide(velocity * delta * 3)

func burst_bullet():
	var quantidade_de_tiros = 2
	if quantidade_de_bullets_voando <= 3:
		quantidade_de_tiros = 2
	if quantidade_de_bullets_voando > 3:
		quantidade_de_tiros = 6 - quantidade_de_bullets_voando
	if can_shoot:
		if easy == true:
			while is_shooting:
				can_shoot = false
				for x in quantidade_de_tiros:
					shoot_bullet()
					await get_tree().create_timer(delay_entre_tiros).timeout
				can_shoot = true
		else:
			can_shoot = false
			for x in quantidade_de_tiros:
				shoot_bullet()
				await get_tree().create_timer(delay_entre_tiros).timeout
			can_shoot = true

func shoot_bullet():
	print('dir: '+str(dir))
	
	SFXShootBullet.play()
	
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = global_transform
	bullet_instance.position += dir * 20
	bullet_instance.motion = dir
	get_parent().add_child(bullet_instance)
	#bullets.append(bullet_instance)
	quantidade_de_bullets_voando += 1
	bullet_instance.die.connect(remove_bullet)
	#get_tree().get_nodes_in_group("Balas").size
	if bullets.size() > 4: #unico lugar que reconhece essa desgraça como > 4
		can_shoot = false
		await get_tree().create_timer(cooldown_arma).timeout
		can_shoot = true

func remove_bullet():
	quantidade_de_bullets_voando = quantidade_de_bullets_voando - 1

func spawn_grenade():
	if can_throw_grenade:
		if Input.is_action_pressed("Grenade"):
			print('dir: '+str(dir))
			can_throw_grenade = false
			await get_tree().create_timer(0.14).timeout #parece ser o tempo original do jogo
			var grenade_instance = grenade.instantiate()
			grenade_instance.global_transform = global_transform
			grenade_instance.motion = Vector2.UP
			grenade_instance.position = grenade_instance.position - Vector2(0,20)
			grenade_instance.dono = "Player"
			get_parent().add_child(grenade_instance)
#			_animated_sprite.play("throw_grenade")
			await get_tree().create_timer(0.72).timeout #tempo real 0.72 + 0.14 total
			can_throw_grenade = true

func _on_area_2d_enemy_collision_area_entered(area: Area2D) -> void:
	print("Area2d enemy collision")
	print("you ded")
	#acho que nao vou usar essa funcao, melhor a morte por tocar no inimigo vir de fora (?)
	pass # Replace with function body.

func death_water(posicao_colisor):
	
	SFXPlayerDeath.play()
	
	can_move = false
	var diferenca_posicao = posicao_colisor - global_position
	diferenca_posicao = Vector2(diferenca_posicao.x/5,diferenca_posicao.y/2)
	var nova_posicao = global_position + diferenca_posicao
	velocity = Vector2(0,0)
	tween = create_tween()
	tween.tween_property(self, "position", nova_posicao, 0.1)
	_animated_sprite.play("death_water")

func death_pitfall(posicao_colisor):
	
	SFXPlayerDeath.play()
	
	can_move = false
	var diferenca_posicao = posicao_colisor - global_position
	diferenca_posicao = Vector2(diferenca_posicao.x/5,diferenca_posicao.y/2)
	var nova_posicao = global_position + diferenca_posicao
	velocity = Vector2(0,0)
	tween = create_tween()
	tween.tween_property(self, "position", nova_posicao, 0.1)
	_animated_sprite.play("death_pitfall")

func death_normal():
	
	SFXPlayerDeath.play()
	
	can_move = false
	velocity = Vector2(0,0)
	_animated_sprite.play("death_normal")
