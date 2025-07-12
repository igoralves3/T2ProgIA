extends CharacterBody2D

@export var type: String
@onready var pontos: int = 200
@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene
var can_shoot: bool = true
var is_enemy: bool = true
var timer_olhar_para_jogador: Timer
var olhando_para_jogador: bool = false
@onready var SFXDeath = $SFXDeath
var motion_direction:= Vector2(1,0)
@onready var _animated_sprite = $AnimatedSprite2D
var tempo_fora_tela: float = 2
@export var camperando: bool = true

signal dead_enemy(myself: CharacterBody2D)

func _ready():
	_animated_sprite.play('atirando')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
	timer_olhar_para_jogador = Timer.new()
	timer_olhar_para_jogador.wait_time = randf_range(1,2)
	timer_olhar_para_jogador.one_shot = true
	timer_olhar_para_jogador.timeout.connect(timer_olhar_para_jogador_end)
	add_child(timer_olhar_para_jogador)


func _physics_process(delta: float) -> void:
	move_and_slide()
	if olhando_para_jogador:
		update_animation(look_at_player())
	else:
		if not camperando:
			update_animation(motion_direction)
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		# get_collider() nos dá o nó com que colidimos.
		if collision and collision.get_collider().is_in_group("GrupoPlayer"):
			
			var superJoe = collision.get_collider()
			
			if superJoe.has_method("death_normal"):
				superJoe.set_collision_layer_value(2, false)
				superJoe.death_normal()



func look_at_player() -> Vector2:
	if other_player:
		var player_position = other_player.global_position
		var direction = other_player.global_position - global_position
		return direction
	return Vector2.DOWN



func update_animation(input_direction: Vector2):
	
	if input_direction.x > 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("right")		
	elif input_direction.x < 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("left")
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y > 0:
		_animated_sprite.play("down")		
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y < 0:
		_animated_sprite.play("up")
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("bottom_right")		
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("top_left")
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("bottom_left")		
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("top_right")
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio


func fire_bullet():
	olhando_para_jogador = true
	timer_olhar_para_jogador.start()
	if other_player:
		var bullet_instance = bullet_inimigo.instantiate()
		#bullet_instance.global_transform = global_transform
		bullet_instance.position = position
		bullet_instance.motion = (other_player.global_position - global_position).normalized()#(ray_cast.target_position).normalized()
		get_parent().add_child(bullet_instance)
		#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func _on_timer_timeout() -> void:
	fire_bullet()

func bullet_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()

func grenade_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	dead_enemy.emit(self)
	queue_free()

func timer_olhar_para_jogador_end():
	olhando_para_jogador = false
	queue_free()
