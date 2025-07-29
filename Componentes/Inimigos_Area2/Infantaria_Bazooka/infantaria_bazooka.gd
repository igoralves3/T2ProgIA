extends CharacterBody2D

class_name InfantariaBazooka

@export var other_player: CharacterBody2D

@export var tiro_bazooka: PackedScene

@onready var _animated_sprite := $AnimatedSprite2D
@onready var timer = $Timer

const SPEED := 100

var atirando := false

var dir = -1

var dir_throw:= Vector2.ZERO

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	
	
func _physics_process(delta: float) -> void:
	if atirando:
		if dir_throw.x > 0:
			_animated_sprite.play('atirando_direita')
		elif dir_throw.x < 0:
			_animated_sprite.play('atirando_esquerda')
		else:
			_animated_sprite.play('atirando_frente')
			
		
		
	else:
		position.x += dir * SPEED * delta
		if other_player:
			var distancia = global_position.distance_to(other_player.global_position)
			var delta_x = abs(global_position.x-other_player.global_position.x)
			var delta_y = abs(global_position.y-other_player.global_position.y)
			if distancia < 50:
				atirando=true
				if delta_x < 10:
					dir_throw=Vector2.DOWN
					
				else:
					if global_position.x + 10 > other_player.global_position.x:
						dir_throw=Vector2(-1,1)
						
					elif global_position.x - 10 < other_player.global_position.x:
						dir_throw=Vector2(1,1)
				timer.start()	
			else:
				_animated_sprite.play('caminhando')
					
				
func fire_bazooka():
	var tiro_bazooka_instance = tiro_bazooka.instantiate()
		#bullet_instance.global_transform = global_transform
	tiro_bazooka_instance.position = global_position
	tiro_bazooka_instance.dir = (dir_throw).normalized()#(ray_cast.target_position).normalized()
	get_parent().add_child(tiro_bazooka_instance)
		#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

		


func _on_timer_timeout() -> void:
	if atirando:
		fire_bazooka()
		atirando=false
	
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
