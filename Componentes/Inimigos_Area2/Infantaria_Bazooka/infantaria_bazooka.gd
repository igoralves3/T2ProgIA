extends CharacterBody2D

class_name InfantariaBazooka

@export var other_player: CharacterBody2D
@export var tiro_bazooka: PackedScene
@export var bazooka_vfx: PackedScene
@onready var _animated_sprite := $AnimatedSprite2D
var old_velocity
const SPEED := 50
var atirando := false
var direcao = 0
var can_shoot: bool = false
var pre_colisao: bool = true
@onready var timer_tiro_animacao = $timer_tiro_animacao
var offset_missil

func _ready():
	_animated_sprite.play("caminhando")
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport_rect().size.x / 2:
		direcao = -1
	else:
		direcao = 1
	_animated_sprite.animation_finished.connect(post_tiro)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if pre_colisao and not atirando:
		global_position = Vector2(global_position.x + direcao * SPEED * delta, global_position.y + -0.2*SPEED*delta)
	if other_player:
		var distancia = other_player.global_position - global_position
		var distancia_normalized = distancia.normalized()
		if distancia_normalized.y > 0 and distancia_normalized.x > -0.55 and distancia_normalized.x < 0.55:
			can_shoot = true
		else:
			can_shoot = false
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision and collision.get_collider().is_in_group("GrupoPlayer"):
			var superJoe = collision.get_collider()
			if superJoe.has_method("death_normal"):
				superJoe.set_collision_layer_value(2, false)
				superJoe.death_normal()
		else:
			update_movimento()
			pre_colisao = false

func pegar_prox_motion():
	var proximo_movimento:= Vector2(0,0)
	if not atirando:
		proximo_movimento = Vector2(randf_range(-1,1),randf_range(-0.7,0.3)).normalized()
	return proximo_movimento

func update_movimento():
	var movendo_para:= Vector2(0,0)
	if other_player:
		movendo_para = pegar_prox_motion()
		velocity = movendo_para * SPEED

func _on_timer_timeout() -> void:
	if can_shoot:
		if not atirando:
			var randi = randi_range(1,4)
			if randi < 4:
				mirar_bazuca()
				atirando=true
				can_shoot = false
				old_velocity = velocity
				velocity = Vector2(0,0)

func mirar_bazuca():
	var direcao_tiro = (other_player.global_position - global_position).normalized()
	if direcao_tiro.x > -0.2 and direcao_tiro.x < 0.2:
		_animated_sprite.play("atirando_frente")
		offset_missil = Vector2(-5,9)
	if direcao_tiro.x > 0.2:
		_animated_sprite.play("atirando_direita")
		offset_missil = Vector2(8,8)
	if direcao_tiro.x < -0.2:
		_animated_sprite.play("atirando_esquerda") #conectado ao post_tiro quando acaba
		offset_missil = Vector2(-8,8)
	timer_tiro_animacao.start()

func _on_timer_tiro_animacao_timeout() -> void:
	fire_bazooka()

func fire_bazooka():
	var tiro_bazooka_instance = tiro_bazooka.instantiate()
	tiro_bazooka_instance.position = position + offset_missil
	var direcao_tiro = (other_player.global_position - global_position).normalized()
	tiro_bazooka_instance.dir = direcao_tiro
	get_parent().add_child(tiro_bazooka_instance)
	var bazuca_vfx = bazooka_vfx.instantiate()
	bazuca_vfx.position = position + offset_missil
	bazuca_vfx.play(_animated_sprite.animation)
	get_parent().add_child(bazuca_vfx)


func post_tiro():
	_animated_sprite.play("caminhando")
	atirando = false
	can_shoot = true
	velocity = old_velocity

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
