extends StaticBody2D
class_name Turret

@export var other_player: CharacterBody2D
@export var bullet_inimigo: PackedScene
@onready var _animated_sprite = $AnimatedSprite2D
@onready var weapon_position = $WeaponPosition
var can_shoot: bool = false
var lives = 2
var pontos = 500
var dir = 1
var shoot_dir = Vector2.DOWN

func _ready() -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport_rect().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
		weapon_position.position.x = -weapon_position.position.x
		shoot_dir = Vector2(-1,1)
		$CollisionShape2D.rotation_degrees = 327
	else:
		_animated_sprite.flip_h = false
		dir = 1
		shoot_dir = Vector2(1,1)
	
func _physics_process(_delta: float) -> void:
	if other_player:
		var delta_x = abs(global_position.x-other_player.global_position.x)
		var delta_y = abs(global_position.y-other_player.global_position.y)
		if delta_x < 70 and delta_y < 70:
			_animated_sprite.play(str(-lives +3)+'atira_reto_baixo')
			if dir < 0:
				shoot_dir = Vector2(-1,1)	
			else:
				shoot_dir = Vector2(1,1)
		elif delta_y < 50:
			_animated_sprite.play(str(-lives + 3)+'atira_reto_cima')
			if dir < 0:
				shoot_dir = Vector2(-1,0)	
			else:
				shoot_dir = Vector2(1,0)
		elif delta_x < 50:
			_animated_sprite.play(str(-lives + 3)+'atira_baixo')
			if dir < 0:
				shoot_dir = Vector2(-0.5,1)	
			else:
				shoot_dir = Vector2(0.5,1)

func _on_timer_timeout() -> void:
	if can_shoot:
		fire_bullet()
	

func fire_bullet():
	var bullet_instance = bullet_inimigo.instantiate()
	bullet_instance.position = weapon_position.global_position
	bullet_instance.dir = (shoot_dir).normalized()
	get_parent().add_child(bullet_instance)

func grenade_hit():
	GameManager.addPoints(pontos)
	lives -= 1
	if lives <= 0:
		set_physics_process(false)
		GameManager.addPoints(pontos)
		set_collision_layer_value(3, false)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	can_shoot = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
