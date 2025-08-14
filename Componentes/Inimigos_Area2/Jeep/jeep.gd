extends Area2D

class_name Jeep

@onready var _animated_sprite = $AnimatedSprite2D
@onready var timer_bullet = $timer_bullet
@onready var weapon_position = $WeaponPosition
var can_shoot: bool = false
var speed := 100
var dir := -1
var alterou_a_velocidade: bool = false
@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene
var lifes := 5
var offset_da_bala
@onready var timer_speed = $timer_reset_speed
var pontos = 200


func _ready() -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")

func _physics_process(delta: float) -> void:
	position.y += dir * speed * delta
	if other_player:
		var distancia_y = other_player.global_position.y - global_position.y
		if distancia_y > 0:
			can_shoot = true
			update_animation((other_player.global_position - Vector2(global_position.x +8,global_position.y)).normalized())
		if distancia_y > 120 and not alterou_a_velocidade:
			speed = 40
			timer_speed.start()
			alterou_a_velocidade = true

func update_animation(distancia_normalized):
	if distancia_normalized.x > -0.15 and distancia_normalized.x < 0.15:
		_animated_sprite.play("atirando_baixo")
		offset_da_bala = Vector2(0,0)
	elif distancia_normalized.x > 0.15 and distancia_normalized.x < 0.45:
		_animated_sprite.play("atirando_direita1")
		offset_da_bala = Vector2(4,0)
	elif distancia_normalized.x > 0.45 and distancia_normalized.x < 0.65:
		_animated_sprite.play("atirando_direita2")
		offset_da_bala = Vector2(6,1)
	elif distancia_normalized.x > 0.65:
		_animated_sprite.play("atirando_direita3")
		offset_da_bala = Vector2(9,-1)
	elif distancia_normalized.x < -0.15 and distancia_normalized.x > -0.45:
		_animated_sprite.play("atirando_esquerda1")
		offset_da_bala = Vector2(-4,0)
	elif distancia_normalized.x < -0.45 and distancia_normalized.x > -0.65:
		_animated_sprite.play("atirando_esquerda2")
		offset_da_bala = Vector2(-7,1)
	elif distancia_normalized.x < -0.65:
		_animated_sprite.play("atirando_esquerda3")
		offset_da_bala = Vector2(-8,0)
	else:
		_animated_sprite.play("atirando_baixo")
		offset_da_bala = Vector2(0,0)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	if can_shoot:
		fire_bullet()

func fire_bullet():
	var bullet_instance = bullet_inimigo.instantiate()
	bullet_instance.position = weapon_position.global_position + offset_da_bala
	bullet_instance.motion = (other_player.global_position-global_position).normalized()
	get_parent().add_child(bullet_instance)

func bullet_hit():
	GameManager.addPoints(pontos)
	lifes-=1
	if lifes <= 0:
		set_collision_layer_value(3, false)
		queue_free()

func _on_timer_reset_speed_timeout() -> void:
	speed = 120

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('death_normal'):
		body.death_normal()
