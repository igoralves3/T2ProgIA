extends CharacterBody2D
class_name Granadeiro

@export var speed: int = 100
@onready var pontos: int = 200
@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene
@export var granada: PackedScene
var can_shoot: bool = false
var timer_olhar_para_jogador: Timer
var timer_jogar_granada: Timer
var olhando_para_jogador: bool = false
var motion_direction:= Vector2(1,0)
@onready var _animated_sprite = $AnimatedSprite2D
var tempo_fora_tela: float = 2
@export var som_morte = AudioStream
@export var som_tiro = AudioStream
@export var colisao_chao: CollisionShape2D
@export var area_colisao_morte: Area2D
@export var camperando: bool = false
@export var fsm_run: Node
var pode_atirar_granada: bool = false
var old_velocity: Vector2
var last_input_direction
var firing_grenade: bool = false
var enemy_controller
var Array_granadas_jogadas: Array
@export var Sprite_frames_caminhando = SpriteFrames
@export var Sprite_frames_camperando = SpriteFrames
@export var Sprite_frames_turret = SpriteFrames
@export var ta_no_turret: bool = false

signal dead_enemy(myself: CharacterBody2D, points: int)

func _ready():
	_animated_sprite.play('down')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	enemy_controller = get_tree().get_first_node_in_group("EnemyController")
	if camperando:
		_animated_sprite.set_sprite_frames(Sprite_frames_camperando)
		if ta_no_turret:
			_animated_sprite.set_sprite_frames(Sprite_frames_turret)
		pode_atirar_granada = false
		_animated_sprite.stop()
		olhando_para_jogador = true
	if not camperando:
		set_collision_mask_value(1, true)
		enemy_controller.update_granadas(0) #adiciona a infantaria atual no array de cooldown se estiver cooldown
	timer_olhar_para_jogador = Timer.new()
	timer_olhar_para_jogador.wait_time = randf_range(1,2)
	timer_olhar_para_jogador.one_shot = true
	timer_olhar_para_jogador.timeout.connect(timer_olhar_para_jogador_end)
	add_child(timer_olhar_para_jogador)
	timer_jogar_granada = Timer.new()
	timer_jogar_granada.wait_time = 1.5
	timer_jogar_granada.timeout.connect(timer_fire_grenade)
	add_child(timer_jogar_granada)
	if other_player.global_position.y < global_position.y:# GameManager.retry == true:
		queue_free()
	timer_jogar_granada.start()


func _physics_process(delta: float) -> void:
	move_and_slide()
	if olhando_para_jogador:
		if not firing_grenade:
			update_animation(look_at_player())
	else:
		if not firing_grenade:
			update_animation(motion_direction)
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision and collision.get_collider().is_in_group("GrupoPlayer"):
			var superJoe = collision.get_collider()
			if superJoe.has_method("death_normal"):
				superJoe.set_collision_layer_value(2, false)
				superJoe.death_normal()
		else:
			fsm_run.update_movimento()
	if not camperando:
		if other_player:
			if other_player.posicao_camera != null:
				var cameraoffset = other_player.posicao_camera
				if global_position.x < 0 or global_position.x > 224:
					tempo_fora_tela = tempo_fora_tela - delta
				if global_position.y > cameraoffset.y +256 or global_position.y < cameraoffset.y:
					tempo_fora_tela = tempo_fora_tela - delta
				if tempo_fora_tela < 0:
					dead_enemy.emit(self, 0)
					queue_free()



func look_at_player() -> Vector2:
	if other_player:
		var player_position = other_player.global_position
		var direction = other_player.global_position - global_position
		return direction
	return Vector2.DOWN



func update_animation(input_direction: Vector2):
	last_input_direction = input_direction
	if input_direction.x > 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("direita")
	elif input_direction.x < 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("esquerda")
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y > 0:
		_animated_sprite.play("baixo")
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y < 0:
		_animated_sprite.play("cima")
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("direita_baixo")
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("esquerda_cima")
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("esquerda_baixo")
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("direita_cima")
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio


func fire_bullet():
	olhando_para_jogador = true
	timer_olhar_para_jogador.start()
	if other_player:
		var bullet_instance = bullet_inimigo.instantiate()
		if camperando:
			bullet_instance.set_collision_mask_value(1, false)
		bullet_instance.position = position
		bullet_instance.motion = (other_player.global_position - global_position).normalized()#(ray_cast.target_position).normalized()
		get_parent().add_child(bullet_instance)
		#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func timer_fire_grenade():
	if not camperando:
		fire_grenade()

func fire_grenade():
	if not firing_grenade:
		firing_grenade = true
		if pode_atirar_granada:
			spawnar_granada()
		_animated_sprite.play("throw")
		old_velocity = velocity
		velocity = Vector2(0,0)
		var timer_end_loop = Timer.new()
		timer_end_loop.wait_time = 0.5
		timer_end_loop.one_shot = true
		timer_end_loop.timeout.connect(post_grenade)
		add_child(timer_end_loop)
		timer_end_loop.start()

func spawnar_granada():
	var grenade_instance = granada.instantiate()
	grenade_instance.global_transform = global_transform
	grenade_instance.position = grenade_instance.position- Vector2(0,20)
	grenade_instance.alvo = other_player.global_position
	grenade_instance.dono = "Granadeiro"
	grenade_instance.enemy_controller = enemy_controller
	enemy_controller.update_granadas(+1)
	get_parent().add_child(grenade_instance)
	Array_granadas_jogadas.append(grenade_instance)

func post_grenade():
	firing_grenade = false
	velocity = old_velocity
	if last_input_direction != null:
		update_animation(last_input_direction)

func bullet_hit():
	set_physics_process(false)
	_animated_sprite.play("death")
	_animated_sprite.animation_finished.connect(queue_free)
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)
	remover_granadas_filhas_do_controller()

func remover_granadas_filhas_do_controller():
	for granada in Array_granadas_jogadas:
		if granada != null:
			if granada.has_method("remover_granada_controller"):
				granada.remover_granada_controller()

func grenade_hit():
	set_physics_process(false)
	_animated_sprite.play("death")
	_animated_sprite.animation_finished.connect(queue_free)
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)
	remover_granadas_filhas_do_controller()

func _on_visible_on_screen_notifier_2d_screen_exited():
	dead_enemy.emit(self, 0)
	remover_granadas_filhas_do_controller()
	queue_free()

func timer_olhar_para_jogador_end():
	if not camperando:
		olhando_para_jogador = false


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	can_shoot = true
	if not camperando:
		pode_atirar_granada = true

func saindo_da_moita():
	_animated_sprite.play("saindo")
	_animated_sprite.animation_finished.connect(saiu_da_moita)
	set_physics_process(false)

func saiu_da_moita():
	_animated_sprite.set_sprite_frames(Sprite_frames_caminhando)
	set_physics_process(true)
	var timer_ativar_collision = Timer.new()
	timer_ativar_collision.wait_time = 0.3
	timer_ativar_collision.one_shot = true
	timer_ativar_collision.timeout.connect(ativar_colisao_chao)
	add_child(timer_ativar_collision)
	timer_ativar_collision.start()

func ativar_colisao_chao():
	set_collision_mask_value(1, true)
