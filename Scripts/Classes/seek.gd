extends State
class_name Seek

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 4.0

var move_direction: Vector2
var wonder_time: float

var destination: Vector2

var chances_random : int = 0
var screen_size

func enter() -> void:
	
	screen_size = get_viewport().size
	
	chances_random=1
	print('seek')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		#timer.start()
	
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
		
		if direction.length() > 25:# and character.global_position.y < other_player.global_position.y:
			character.velocity = direction.normalized() * move_speed
		else:
			character.velocity = Vector2(0,0)
		"""	
		if randi_range(0,10) > 5:
			chances_random -= 1
		if chances_random <= 0:
			transitioned.emit(self,"Wander")	
		"""
		if direction.length() < 100:# or character.global_position.y > other_player.global_position.y:
			transitioned.emit(self,"Wander")
			
			


#func _on_timer_timeout() -> void:
#	print('time to shoot')
	#fire_bullet()
	#timer.start(10.0)
	
