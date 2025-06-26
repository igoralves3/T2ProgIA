extends State
class_name Seek

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 40.0

var move_direction: Vector2
var wonder_time: float

var destination: Vector2

@export var bullet_inimigo: PackedScene

#@export var ray_cast : RayCast2D

@export var timer: Timer

"""
func fire_bullet():
	
	var dir = (ray_cast.target_position).normalized()
	
	var bullet_instance = bullet_inimigo.instantiate()
	#bullet_instance.global_transform = get_parent().get_parent().global_transform
	bullet_instance.position = get_parent().get_parent().position
	bullet_instance.motion = dir
	bullet_instance.is_moving = true
	get_tree().current_scene.add_child(bullet_instance)
	print(str(bullet_instance.position) + " " + str(get_parent().get_parent().position))

func aim():
	if other_player:
		ray_cast.target_position = get_parent().get_parent().to_local(other_player.position)
	
"""

func enter() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		timer.start()
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	#aim()
	
func physics_update(delta: float) -> void:
	if !other_player:
		return
	else:
		var direction = other_player.global_position - character.global_position
		
		for i in character.get_slide_collision_count():
			var collision = character.get_slide_collision(i)
			print("I collided with ", collision.get_collider().name)
		
		if direction.length() > 25 and character.global_position.y < other_player.global_position.y:
			character.velocity = direction.normalized() * move_speed
		else:
			character.velocity = Vector2(0,0)
			
		if direction.length() > 150 or character.global_position.y > other_player.global_position.y:
			transitioned.emit(self,"Wander")
			
			
		#aim()
		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('fora')
	get_parent().get_parent().queue_free()


func _on_timer_timeout() -> void:
	print('time to shoot')
	#fire_bullet()
	#timer.start(10.0)
	
"""
func randomize_wonder():
	move_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wonder_time = randf_range(1,5)


func update_position() -> void:
	var direction = destination - character.global_position
	character.velocity = direction.normalized() * move_speed

func enter() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
	randomize_wonder()
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if wonder_time > 0:
		wonder_time -= delta
	else:
		randomize_wonder()
	
func physics_update(delta: float) -> void:
	if character:
		character.velocity = move_direction * move_speed
	if other_player:
		var direction = other_player.global_position - character.global_position
		
		if direction.length() < 250:
			print('proximo')
			
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('fora')
	queue_free()
"""
