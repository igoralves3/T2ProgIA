extends Area2D
class_name Turret


@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene

@onready var _animated_sprite = $AnimatedSprite2D

var lifes = 2
var pontos = 500
var dir = 1
var shoot_dir = Vector2.DOWN

@onready var weapon_position = $WeaponPosition

func _ready() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport_rect().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
		weapon_position.position.x = -weapon_position.position.x
		shoot_dir = Vector2(-1,1)
	else:
		_animated_sprite.flip_h = false
		dir = 1
		shoot_dir = Vector2(1,1)
	
func _physics_process(delta: float) -> void:
	
	var state_life =1
	if lifes == 1:
		state_life=2
	
	if other_player:
		var distancia = global_position.distance_to(other_player.global_position)
		var delta_x = abs(global_position.x-other_player.global_position.x)
		var delta_y = abs(global_position.y-other_player.global_position.y)
		
		
		if distancia < 50:
			print('turret proximo ao player')
		if delta_x < 70 and delta_y < 70:
			_animated_sprite.play(str(state_life)+'atira_reto_baixo')
			
			if dir < 0:
				shoot_dir = Vector2(-1,1)	
			else:
				shoot_dir = Vector2(1,1)
		elif delta_y < 50:
			
			_animated_sprite.play(str(state_life)+'atira_reto_cima')
			if dir < 0:
				shoot_dir = Vector2(-1,0)	
			else:
				shoot_dir = Vector2(1,0)
		elif delta_x < 50:	
			
			_animated_sprite.play(str(state_life)+'atira_baixo')
			if dir < 0:
				shoot_dir = Vector2(-0.5,1)	
			else:
				shoot_dir = Vector2(0.5,1)


func _on_timer_timeout() -> void:
	fire_bullet()
	

func fire_bullet():
	var bullet_instance = bullet_inimigo.instantiate()
	#bullet_instance.global_transform = global_transform
	bullet_instance.position = weapon_position.global_position
	bullet_instance.motion = (shoot_dir).normalized()#(ray_cast.target_position).normalized()
	get_parent().add_child(bullet_instance)
	#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func grenade_hit():
	GameManager.addPoints(pontos)
	lifes -= 1
	print('explosao 1')
	if lifes <= 0:
		GameManager.addPoints(pontos)
		set_collision_layer_value(3, false)
		print('explosao 2')
		queue_free()
