extends CharacterBody2D

@export var other_player: CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

@export var _infantaria: PackedScene

func _ready():
	_animated_sprite.play('down')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")	

func _physics_process(delta: float) -> void:
	if other_player:
		var distance := global_position.distance_to(other_player.global_position)
		if distance < 100:
			update_animation(look_at_player())
			
		if distance < 50:
			andar_pela_cena()
			

func look_at_player() -> Vector2:
	if other_player:
		var player_position = other_player.global_position
		var direction = other_player.global_position - global_position
		return direction
	return Vector2.DOWN
	
func update_animation(input_direction: Vector2):
	
	if input_direction.x > 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("right")		
	elif input_direction.x < 0 and (input_direction.y > -10 and input_direction.y < 10):
		_animated_sprite.play("left")
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y > 0:
		_animated_sprite.play("down")		
	elif (input_direction.x > -10 and input_direction.x < 10) and input_direction.y < 0:
		_animated_sprite.play("up")
	elif input_direction.x > 0 and input_direction.y > 0:
		_animated_sprite.play("bottom_right")		
	elif input_direction.x < 0 and input_direction.y < 0:
		_animated_sprite.play("top_left")
	elif  input_direction.x < 0 and input_direction.y > 0:
		_animated_sprite.play("bottom_left")		
	elif input_direction.x > 0 and input_direction.y < 0:
		_animated_sprite.play("top_right")
	else:
		_animated_sprite.stop()
	#	_animated_sprite.frame = 0 #o jogo não usa a princípio

func andar_pela_cena():
	var infantaria_instance = _infantaria.instantiate()
	
	infantaria_instance.global_position = global_position
	
	get_parent().add_child(infantaria_instance)
	
	queue_free()
