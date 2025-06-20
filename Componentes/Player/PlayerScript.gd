extends CharacterBody2D
var canShoot: bool = true

const SPEED = 68.0 # 3 segundos pra atravessar a tela da esquerda pra direita

@export var bullet :PackedScene
@export var grenade :PackedScene

@onready var _animated_sprite = $PlayerSprite

var bullets = []
var easy:= false
var delay_entre_tiros: float = 0.055 # é por ai
var cooldown_arma: float = 0.5 
var can_shoot := true
var can_throw_grenade := true
var is_shooting:= false
var quantidade_de_bullets_voando: int = 0 

var dir:= Vector2(0,1)

func _physics_process(delta: float) -> void:
	move_8_way(delta)
	move_and_slide()
	if velocity != Vector2.ZERO:
		dir = velocity.normalized()
	bullets = bullets.filter(func(bullet):
		return is_instance_valid(bullet) and bullet.get_parent() != null)
	#print(quantidade_de_bullets_voando)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"): #atira se não tiver 5 ou mais balas voando
		is_shooting = true
		burst_bullet()
	
	if event.is_action_released("Shoot"):
		is_shooting = false
	
	if event.is_action_pressed("Grenade"):
		spawn_grenade()


func update_animation(input_direction: Vector2) -> void:
	
	
	if input_direction.x > 0 and input_direction.y == 0:
		_animated_sprite.play("run_right")		
	elif input_direction.x < 0 and input_direction.y == 0:
		_animated_sprite.play("run_left")
	elif  input_direction.x == 0 and input_direction.y > 0:
		_animated_sprite.play("run_down")		
	elif input_direction.x == 0 and input_direction.y < 0:
		_animated_sprite.play("run_up")
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_right")		
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_left")
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("run_bottom_left")		
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("run_top_right")
	elif can_throw_grenade == false:
		_animated_sprite.play("throw_grenade")
		await get_tree().create_timer(0.3).timeout
		_animated_sprite.stop()
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio
		
		

func get_8_way_input() -> void:
	var input_direction = Input.get_vector("Left","Right","Up","Down")
		
	update_animation(input_direction)	
		
		
	velocity = input_direction * SPEED
	
	

func move_8_way(delta: float) -> void:
	get_8_way_input() # \/ será usado mais a frente
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info:
	#	var collision_point = collision_info.get_position()
		
	#	velocity = velocity.bounce(collision_info.get_normal())
	#	move_and_collide(velocity * delta * 3)
		
#	animate_8_way()


func burst_bullet():
	var quantidade_de_tiros = 2
	if quantidade_de_bullets_voando <= 3:
		quantidade_de_tiros = 2
	if quantidade_de_bullets_voando > 3:
		quantidade_de_tiros = 6 - quantidade_de_bullets_voando
	if can_shoot:
		if easy == true:
			while is_shooting:
				can_shoot = false
				for x in quantidade_de_tiros:
					shoot_bullet()
					await get_tree().create_timer(delay_entre_tiros).timeout
				can_shoot = true
		else:
			can_shoot = false
			for x in quantidade_de_tiros:
				shoot_bullet()
				await get_tree().create_timer(delay_entre_tiros).timeout
			can_shoot = true

func shoot_bullet():
	print('dir: '+str(dir))
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = global_transform
	bullet_instance.position += dir * 20
	bullet_instance.motion = dir
	get_parent().add_child(bullet_instance)
	#bullets.append(bullet_instance)
	quantidade_de_bullets_voando += 1
	bullet_instance.die.connect(remove_bullet)
	#get_tree().get_nodes_in_group("Balas").size
	if bullets.size() > 4: #unico lugar que reconhece essa desgraça como > 4
		can_shoot = false
		await get_tree().create_timer(cooldown_arma).timeout
		can_shoot = true

func remove_bullet():
	quantidade_de_bullets_voando = quantidade_de_bullets_voando - 1
	
func spawn_grenade():
	if can_throw_grenade:
		if Input.is_action_pressed("Grenade"):
			print('dir: '+str(dir))
			can_throw_grenade = false
			await get_tree().create_timer(0.14).timeout #parece ser o tempo original do jogo
			var grenade_instance = grenade.instantiate()
			grenade_instance.global_transform = global_transform
			grenade_instance.position += dir * 40
			grenade_instance.motion = dir
			get_parent().add_child(grenade_instance)
#			_animated_sprite.play("throw_grenade")
			await get_tree().create_timer(0.72).timeout #tempo real 0.72 + 0.14 total
			can_throw_grenade = true

func _on_area_2d_enemy_collision_area_entered(area: Area2D) -> void:
	print("Area2d enemy collision")
	print("you ded")
	pass # Replace with function body.
