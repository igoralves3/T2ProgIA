extends CharacterBody2D
var canShoot: bool = true

const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


@export var bullet :PackedScene
@export var granade :PackedScene

var can_shoot := true
var can_throw_granade := true

var dir:= Vector2(0,1)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction := Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_8_way(delta)
	move_and_slide()
	if velocity != Vector2.ZERO:
		dir = velocity.normalized()
	
	spawn_bullet()
	spawn_granade()

func get_8_way_input() -> void:
	var input_direction = Input.get_vector("Left","Right","Up","Down")
	velocity = input_direction * SPEED
	
	

func move_8_way(delta: float) -> void:
	get_8_way_input()
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info:
	#	var collision_point = collision_info.get_position()
		
	#	velocity = velocity.bounce(collision_info.get_normal())
	#	move_and_collide(velocity * delta * 3)
		
#	animate_8_way()
	
#func animate_8_way():
#	if velocity.x > 0:
#		sprite.play("Direita")
#	elif velocity.x < 0:
#		sprite.play("Esquerda")
#	elif velocity.y > 0:
#		sprite.play("Baixo")
#	elif velocity.y < 0:
#		sprite.play("Cima")
#	else:
#		sprite.stop()

func spawn_bullet():
	if can_shoot:
		
		if Input.is_action_pressed("Shoot"):
			print('dir: '+str(dir))
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_transform = global_transform
			bullet_instance.position += dir * 40
			bullet_instance.motion = dir
			get_parent().add_child(bullet_instance)
			
			can_shoot = false
			await get_tree().create_timer(1.0).timeout
			can_shoot = true
			
func spawn_granade():
	if can_throw_granade:
		if Input.is_action_pressed("Granade"):
			print('dir: '+str(dir))
			var granade_instance = granade.instantiate()
			granade_instance.global_transform = global_transform
			granade_instance.position += dir * 40
			granade_instance.motion = dir
			get_parent().add_child(granade_instance)
			
			can_throw_granade = false
			await get_tree().create_timer(1.0).timeout
			can_throw_granade = true
	
