extends Area2D

class_name Humvee
@onready var _animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var weapon_position = $WeaponPosition
const speed := 100
var dir := 1
@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene

func _ready() -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport_rect().size.x / 2:
		dir = -1
		_animated_sprite.play("andando_p_esquerda")
	else:
		dir = 1
		_animated_sprite.play("andando_p_direita")

func _physics_process(delta: float) -> void:
	position.x += dir * speed * delta

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('death_normal'):
		body.death_normal()

func fire_bullet():
	if other_player:
		if other_player.global_position.y > global_position.y:
			var bullet_instance = bullet_inimigo.instantiate()
			bullet_instance.position = weapon_position.global_position
			bullet_instance.motion = (Vector2.DOWN).normalized()
			get_parent().add_child(bullet_instance)

func _on_timer_timeout() -> void:
	fire_bullet()
