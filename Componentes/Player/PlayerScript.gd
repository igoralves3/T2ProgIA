extends CharacterBody2D
class_name Player

const SPEED = 68.0 # 3 segundos pra atravessar a tela da esquerda pra direita
@export var god_mode: bool = false
@export var bullet :PackedScene
@export var grenade :PackedScene
@onready var _animated_sprite = $PlayerSprite
@onready var camera = %Camera2D
@export var SFXShootBullet = AudioStream
@export var SFXPlayerDeath = AudioStream
@export var Bullet_VFX: PackedScene
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
var is_reloading_scene: bool = false
var bullet_offset
@export var grenadeAmmo: int = 50
var last_input_direction = "run_up"
var dying = false
var cooldown_da_arma: bool = false
var HUD
signal dead_player

func _ready() -> void:
	is_reloading_scene = false
	await get_tree().process_frame
	tamanho_tela = get_viewport_rect().size
	dir = Vector2(0,-1) # comeca olhando pra cima
	get_HUD()
	HUD.single_update()

func _process(delta):
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
	get_8_way_input()
	move_and_slide()
	if velocity != Vector2.ZERO:
		dir = velocity.normalized()
	bullets = bullets.filter(func(bullet):
		return is_instance_valid(bullet) and bullet.get_parent() != null)
	if cooldown_da_arma:
		can_shoot = false

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
		last_input_direction = "run_right"
	elif input_direction.x < 0 and input_direction.y == 0:
		_animated_sprite.play("run_left")
		last_input_direction = "run_left"
	elif  input_direction.x == 0 and input_direction.y > 0:
		_animated_sprite.play("run_down")
		last_input_direction = "run_down"
	elif input_direction.x == 0 and input_direction.y < 0:
		_animated_sprite.play("run_up")
		last_input_direction = "run_up"
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_right")
		last_input_direction = "run_button_right"
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_left")
		last_input_direction = "run_top_left"
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_left")
		last_input_direction = "run_bottom_left"
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_right")
		last_input_direction = "run_top_right"
	elif can_throw_grenade == false:
		_animated_sprite.play("throw_grenade")
		var timer1 = get_tree().create_timer(0.3) #tem que arrumar aqui, ta ruim a animacao
		timer1.timeout.connect(stop_animated_sprite)
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio

func stop_animated_sprite():
	if not dying:
		if can_throw_grenade == false:
			_animated_sprite.stop()

func get_8_way_input() -> void:
	var input_direction = Input.get_vector("Left","Right","Up","Down")
	if can_move:
		update_animation(input_direction)	
		velocity = input_direction * SPEED


func burst_bullet():
	var quantidade_de_tiros = 1
#	if quantidade_de_bullets_voando <= 3:
#		quantidade_de_tiros = 2
#	if quantidade_de_bullets_voando > 3:
#		quantidade_de_tiros = 6 - quantidade_de_bullets_voando
	if can_shoot:
		if can_throw_grenade == false:
			_animated_sprite.play(last_input_direction)
		if easy == true:
			while is_shooting:
				can_shoot = false
				for x in quantidade_de_tiros:
					shoot_bullet()
					var timer1 = get_tree().create_timer(delay_entre_tiros)
					timer1.timeout.connect(shoot_bullet)
		else:
			can_shoot = false
			for x in quantidade_de_tiros:
				shoot_bullet()
				var timer2 = get_tree().create_timer(delay_entre_tiros)
				timer2.timeout.connect(shoot_bullet)
				timer2.timeout.connect(enable_bullet_shooting)

func shoot_bullet():
#	print('dir: '+str(dir))
	var direcao_anim
	SoundController.play_button(SFXShootBullet)
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = global_transform
	if dir == Vector2(0, -1):  #arruma a posicao do tiro olhando para cima
		bullet_instance.position += Vector2(dir.x * 15 + 6,dir.y * 15 +2)
		bullet_offset = Vector2(dir.x * 15 + 6,dir.y * 15 +2)
		direcao_anim = "U"
	elif dir == Vector2(0, 1):  #baixo
		bullet_instance.position += Vector2(dir.x * 15 + -3,dir.y * 15 -6)
		bullet_offset = Vector2(dir.x * 15 + -3,dir.y * 15 -6)
		direcao_anim = "D"
	elif dir == Vector2(-1, 0): #esquerda
		bullet_instance.position += Vector2(dir.x * 15,dir.y * 15 -2)
		bullet_offset = Vector2(dir.x * 15,dir.y * 15 -1)
		direcao_anim = "L"
	elif dir == Vector2(1, 0): #direita
		bullet_instance.position += Vector2(dir.x * 15,dir.y * 15 -2)
		bullet_offset = Vector2(dir.x * 15,dir.y * 15 -1)
		direcao_anim = "R"
	elif dir.x > 0.7 and dir.x < 0.71 and dir.y < 0.7: #diagonal direita cima
		bullet_instance.position += Vector2(dir.x * 15 + +1,dir.y * 15 +3)
		bullet_offset = Vector2(dir.x * 15 + +1,dir.y * 15 +3)
		direcao_anim = "UR"
	elif dir.x < -0.7 and dir.x > -0.71 and dir.y < -0.7: #up left eu acho
		bullet_instance.position += Vector2(dir.x * 15 -1,dir.y * 15 +3)
		bullet_offset = Vector2(dir.x * 15 -1,dir.y * 15 +3)
		direcao_anim = "UL"
	elif dir.x > 0.7 and dir.x < 0.71 and dir.y > 0.7: #diagonal direita baixo
		bullet_instance.position += Vector2(dir.x * 15 + -3,dir.y * 15 -4)
		bullet_offset = Vector2(dir.x * 15 + -3,dir.y * 15 -4)
		direcao_anim = "DR"
	elif dir.x < -0.7 and dir.x > -0.71 and dir.y > 0.7: #diagonal esquerda baixo
		bullet_instance.position += Vector2(dir.x * 15 + +3,dir.y * 15 -4)
		bullet_offset = Vector2(dir.x * 15 + +3,dir.y * 15 -4)
		direcao_anim = "DL"
	else:
		bullet_instance.position += dir * 15
	var vfx_instance = Bullet_VFX.instantiate()
	if direcao_anim != null and bullet_offset != null:
		vfx_instance.global_position = global_position + bullet_offset
		vfx_instance.play(direcao_anim)
		get_parent().add_child(vfx_instance)
	bullet_instance.motion = dir
	get_parent().add_child(bullet_instance)
	#bullets.append(bullet_instance)
	quantidade_de_bullets_voando += 1
	bullet_instance.die.connect(remove_bullet)
	#get_tree().get_nodes_in_group("Balas").size
	if quantidade_de_bullets_voando > 4: #unico lugar que reconhece essa desgraça como > 4
		cooldown_da_arma = true
		var timer1 = get_tree().create_timer(cooldown_arma)
		timer1.timeout.connect(acabou_cooldown_da_arma)

func remove_bullet():
	quantidade_de_bullets_voando = quantidade_de_bullets_voando - 1

func spawn_grenade():
	if can_throw_grenade and grenadeAmmo > 0:
		if Input.is_action_pressed("Grenade"):
#			print('dir: '+str(dir))
			can_throw_grenade = false
			grenadeAmmo-=1
			GameManager.granadas = grenadeAmmo
			_animated_sprite.play("throw_grenade")
			var timer1 = get_tree().create_timer(0.14) #parece ser o tempo original do jogo
			timer1.timeout.connect(spawn_grenade_part2)
			if HUD != null:
				HUD.single_update()
			else:
				get_HUD()
				HUD.single_update()


func spawn_grenade_part2():
	var grenade_instance = grenade.instantiate()
	grenade_instance.global_transform = global_transform
	grenade_instance.motion = Vector2.UP
	grenade_instance.position = grenade_instance.position - Vector2(0,20)
	grenade_instance.dono = "Player"
	get_parent().add_child(grenade_instance)
	var timer4 = get_tree().create_timer(0.72) #tempo real 0.72 + 0.14 total
	timer4.timeout.connect(enable_grenades)

func death_water(posicao_colisor):
	if not god_mode:
		disable_collisions()
		SoundController.play_button(SFXPlayerDeath)
		can_move = false
		can_shoot = false
		var diferenca_posicao = posicao_colisor - global_position
		diferenca_posicao = Vector2(diferenca_posicao.x/5,diferenca_posicao.y/5)
		var nova_posicao = global_position + diferenca_posicao
		velocity = Vector2(0,0)
		tween = create_tween()
		tween.tween_property(self, "position", nova_posicao, 0.1)
		_animated_sprite.play("death_water")
		_animated_sprite.animation_finished.connect(emit_death)
#	emit_death()

func death_pitfall(posicao_colisor):
	if not god_mode:
		disable_collisions()
		SoundController.play_button(SFXPlayerDeath)
		can_move = false
		can_shoot = false
		print (posicao_colisor, "colisor")
		print (global_position, "global")
		var diferenca_posicao = posicao_colisor - global_position
		diferenca_posicao = Vector2(diferenca_posicao.x/4,diferenca_posicao.y)
		print (diferenca_posicao, "diferenca")
		var nova_posicao = global_position + diferenca_posicao
		print (nova_posicao, "nova posicao")
		velocity = Vector2(0,0)
		tween = create_tween()
		tween.tween_property(self, "position", nova_posicao, 0.1)
		_animated_sprite.play("death_pitfall")
		_animated_sprite.animation_finished.connect(emit_death)
#	emit_death()

func death_normal():
#	print ("death normals playerscript")
	if not god_mode:
		disable_collisions()
		SoundController.play_button(SFXPlayerDeath)
		can_move = false
		can_shoot = false
		velocity = Vector2(0,0)
		_animated_sprite.play("death_normal")
		_animated_sprite.animation_finished.connect(emit_death)
#	emit_death()

func disable_collisions():
	dying = true
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_layer_value(4, false)
	set_collision_layer_value(5, false)
	$Area2DEnemyCollision.set_collision_layer_value(2, false)

func emit_death():
	print ("emit death before bool")
	if not is_reloading_scene:
		print("emit death after bool")
		is_reloading_scene = true
		dead_player.emit()

func enable_bullet_shooting():
	if not dying:
		can_shoot = true

func acabou_cooldown_da_arma():
	if not dying:
		cooldown_da_arma = false
		can_shoot = true

func enable_grenades():
	if not dying:
		can_throw_grenade = true
		_animated_sprite.play(last_input_direction)

func get_HUD():
	var HUD1 = get_tree().get_nodes_in_group("HUD")
	if not HUD1.is_empty():
		HUD = HUD1[0]
