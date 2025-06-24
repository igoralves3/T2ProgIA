extends State
class_name Wander


@export var character: CharacterBody2D
@export var other_player: CharacterBody2D

@export var move_speed: float = 40.0

@export var _animated_sprite: AnimatedSprite2D

var move_direction: Vector2
const SPEED = 150.0

@onready var player = $Player
var wonder_time: float

var destination: Vector2

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
		
		if direction.length() < 150:
			transitioned.emit(self,"Seek")
			
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('fora')
	queue_free()

"""
func enter() -> void:
	if character:
		print('enter')
		if character.position.x < get_viewport().size.x / 2:
			move_direction = Vector2(-1,0)
		elif character.position.x > get_viewport().size.x / 2:
			move_direction = Vector2(1,0)
		else:
			var r = randi() % 2
			if r == 0:
				move_direction = Vector2(1,0)
			else:
				move_direction = Vector2(-1,0)
				
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')	
	
	
	
	
		
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if character:
		character.velocity = move_direction * SPEED
		for i in character.get_slide_collision_count():
			var collision = character.get_slide_collision(i)
			print("I collided with ", collision.get_collider().name)
	if other_player:
		var direction = other_player.global_position - character.global_position
		if direction.length() < 250:
			transitioned.emit(self,"Seek")
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('fora')
	queue_free()
"""
