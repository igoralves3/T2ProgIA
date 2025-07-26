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
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
		_animated_sprite.play("andando_p_esquerda")
	else:
		_animated_sprite.flip_h = false
		dir = 1
		_animated_sprite.play("andando_p_direita")

func _physics_process(delta: float) -> void:
	if dir > 0:
		_animated_sprite.play("andando_p_esquerda")
	elif dir < 0:
		_animated_sprite.play("andando_p_direita")
	position.x += dir * speed * delta

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('humvee fora')
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('player colidiu')
		if body.has_method('death_normal'):
			body.death_normal()
			
func fire_bullet():
	var bullet_instance = bullet_inimigo.instantiate()
	#bullet_instance.global_transform = global_transform
	bullet_instance.position = weapon_position.global_position
	bullet_instance.motion = (Vector2.DOWN).normalized()#(ray_cast.target_position).normalized()
	get_parent().add_child(bullet_instance)
	#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")


func _on_timer_timeout() -> void:
	fire_bullet()
