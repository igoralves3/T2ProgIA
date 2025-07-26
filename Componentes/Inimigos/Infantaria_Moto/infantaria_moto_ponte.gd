extends Area2D

const SPEED := 50
var parada = false
var em_movimento = true
var indo_embora = false
#var pode_parar = true
#var frames_parada = 0.0
var other_player : CharacterBody2D
@export var grenade :PackedScene
var pode_atirar_granada = false
@onready var _animated_sprite2d := $AnimatedSprite2D
@export var distancia_player_ir_embora: float = 50
@export var global_x_parar_moto: float = 120

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if parada == false:
		_animated_sprite2d.play("moto_azul")

func _physics_process(delta: float) -> void:
	if em_movimento == true:
		position.x = position.x -SPEED * delta
		if global_position.x <= global_x_parar_moto:
			em_movimento = false
			parada = true

	if parada == true:
		_animated_sprite2d.play("granada")
		pode_atirar_granada = true
		#frames_parada += delta + 1
		#var frame_anim = _animated_sprite2d.frame
		#if frame_anim == 3:
#			parada = false
		#	can_throw_grenade=false
		#	throw_grenade()
#		if other_player:
#			if global_position.x >= other_player.global_position.x - 25 and global_position.x <= other_player.global_position.x + 25:
#			if global_position.y >= other_player.global_position.x - 25 and global_position.x <= other_player.global_position.x + 25:
				#if pode_parar and can_throw_grenade: #olhar aqui
#				parada = true
#				pode_parar = false
#	else:
#		if other_player:
#			if not (global_position.x >= other_player.global_position.x - 25 and
#			 global_position.x <= other_player.global_position.x + 25):
#				parada = false
#		_animated_sprite2d.play("granada")
#		frames_parada += delta + 1
#		var frame_anim = _animated_sprite2d.frame
#		#if frames_parada >= 120:
#			#parada = false
#		#if frames_parada >= 60:
#		if frame_anim == 3:
#			#frames_parada=0
			#if can_throw_grenade:
#			parada = false
#			can_throw_grenade=false
#			throw_grenade()
		if global_position.y >= other_player.global_position.y - distancia_player_ir_embora:
			if indo_embora == false:
				_animated_sprite2d.play("moto_azul")
				parada = false
				indo_embora = true
	if indo_embora == true:
		position.x = position.x -SPEED * delta

func fire_grenade():
	var grenade_instance = grenade.instantiate()
	grenade_instance.global_transform = global_transform
	grenade_instance.motion = Vector2.DOWN
	grenade_instance.position = grenade_instance.position- Vector2(0,20)
	grenade_instance.dono = "Moto"
	grenade_instance.alvo = other_player.global_position
	get_parent().add_child(grenade_instance)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('moto fora')
	
	queue_free()
