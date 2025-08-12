extends Area2D

const SPEED := 50
var parada = false
var em_movimento = true
var indo_embora = false
var other_player : CharacterBody2D
@export var grenade :PackedScene
var pode_atirar_granada = false
@onready var _animated_sprite2d := $AnimatedSprite2D
@export var distancia_player_ir_embora: float = 50
@export var global_x_parar_moto: float = 120

func _ready():
	if not other_player:
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
	grenade_instance.position = grenade_instance.position- Vector2(0,20)
	grenade_instance.dono = "Moto"
	grenade_instance.alvo = other_player.global_position
	get_parent().add_child(grenade_instance)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
