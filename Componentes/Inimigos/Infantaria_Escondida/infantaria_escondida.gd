extends CharacterBody2D

@export var _animated_sprite: AnimatedSprite2D
@export var infantaria_submersa: SpriteFrames
@export var infantaria_pitfall: SpriteFrames
@export var submersa: bool = true
const SPEED = 0
var other_player: CharacterBody2D
var escondendo: bool = true
var timer_esconder_sair: Timer
var timer_esconder_sair_parte_2: Timer
var can_shoot: bool = false
var active: bool = false
@export var bullet_inimigo: PackedScene
var offset_da_bala
@export var som_morte: AudioStream
var pontos: int = 200
var bool_uma_vez: bool = false
signal dead_enemy(myself: CharacterBody2D, points: int)

func _ready() -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if not submersa:
		_animated_sprite.sprite_frames = infantaria_pitfall
	_animated_sprite.play("escondendo")
	timer_esconder_sair = Timer.new()
	timer_esconder_sair.wait_time = randf_range(1,1.5)
	timer_esconder_sair.one_shot = true
	add_child(timer_esconder_sair)
	timer_esconder_sair.stop()
	timer_esconder_sair.timeout.connect(timer_esconder_sair_end)
	timer_esconder_sair_parte_2 = Timer.new()
	timer_esconder_sair_parte_2.wait_time = 0.3
	timer_esconder_sair_parte_2.one_shot = true
	add_child(timer_esconder_sair_parte_2)
	timer_esconder_sair_parte_2.stop()
	timer_esconder_sair_parte_2.timeout.connect(timer_esconder_sair_parte_2_end)

func look_at_player() -> Vector2:
	if other_player:
		var direction = other_player.global_position - global_position
		return direction
	return Vector2.DOWN

func _physics_process(_delta: float) -> void:
	if not escondendo:
		update_animation(look_at_player().normalized())
	if other_player.global_position.y < global_position.y:
		escondendo = true
		_animated_sprite.play("escondendo")
		if not bool_uma_vez:
			_animated_sprite.animation_finished.connect(queue_free)
			bool_uma_vez = true

func update_animation(distancia_normalized):
	if distancia_normalized.x > -0.2 and distancia_normalized.x < 0.2:
		_animated_sprite.play("frente")
		offset_da_bala = Vector2(-4,7)
	elif distancia_normalized.x > 0.20:
		_animated_sprite.play("direita")
		offset_da_bala = Vector2(2,9)
	elif distancia_normalized.x < -0.2:
		_animated_sprite.play("esquerda")
		offset_da_bala = Vector2(-7,8)
	else:
		_animated_sprite.play("frente")
		offset_da_bala = Vector2(-4,7)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
	timer_esconder_sair.start()

func timer_esconder_sair_end():
	if escondendo:
		_animated_sprite.play("saindo")
		timer_esconder_sair.wait_time = 1
		timer_esconder_sair_parte_2.start()
	if not escondendo:
		escondendo = true
		can_shoot = false
		_animated_sprite.play("escondendo")
		timer_esconder_sair.wait_time = randf_range(1,1.5)
		timer_esconder_sair.start()
		timer_esconder_sair_parte_2.start()

func timer_esconder_sair_parte_2_end():
	if _animated_sprite.animation == "saindo":
		escondendo = false
		can_shoot = true
		timer_esconder_sair.start()
	else:
		timer_esconder_sair.start()

func fire_bullet():
	if other_player:
		var bullet_instance = bullet_inimigo.instantiate()
#		if escondendo:
#			bullet_instance.set_collision_mask_value(1, false)
		bullet_instance.position = position + offset_da_bala
		bullet_instance.motion = (other_player.global_position - global_position).normalized()
		get_parent().add_child(bullet_instance)

func grenade_hit():
	set_physics_process(false)
	_animated_sprite.play("morrendo")
	_animated_sprite.animation_finished.connect(queue_free)
	set_collision_layer_value(3, false)
	GameManager.addPoints(pontos)
	SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)
