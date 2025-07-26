extends CharacterBody2D

class_name Jeep

@onready var _animated_sprite = $AnimatedSprite2D

@onready var timer = $Timer
@onready var weapon_position = $WeaponPosition

const speed := 100

var dir := -1

@export var other_player: CharacterBody2D

@export var bullet_inimigo: PackedScene

var lifes := 5

func _ready() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	
	
	
func _physics_process(delta: float) -> void:
	position.y += dir * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('jeep fora')
	queue_free()


func _on_timer_timeout() -> void:
	fire_bullet()
	
func fire_bullet():
	var bullet_instance = bullet_inimigo.instantiate()
	#bullet_instance.global_transform = global_transform
	bullet_instance.position = weapon_position.global_position
	bullet_instance.motion = (Vector2.DOWN).normalized()#(ray_cast.target_position).normalized()
	get_parent().add_child(bullet_instance)
	#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

"""
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('player colidiu')
		if body.has_method('death_normal'):
			body.death_normal()
"""
	 
func bullet_hit():
	lifes-=1
	if lifes <= 0:
		set_collision_layer_value(3, false)
		queue_free()

#func _on_area_entered(area: Area2D) -> void:
#	pass
	#if area is PlayerBullet:
		#print('bala do player no jeep')
		#lifes-=1
		#if lifes <= 0:
			#queue_free()
