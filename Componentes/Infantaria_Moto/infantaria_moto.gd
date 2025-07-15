extends Area2D

const SPEED := 50

var parada = false
var pode_parar = true

var frames_parada = 0.0

var other_player : CharacterBody2D



@export var grenade :PackedScene

var can_throw_grenade = true

@onready var _animated_sprite2d := $AnimatedSprite2D

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')


func _physics_process(delta: float) -> void:
	
	if parada == false:
		_animated_sprite2d.play("moto_azul")
		position.x = position.x -SPEED * delta
		if other_player:
			if global_position.x >= other_player.global_position.x - 25 and global_position.x <= other_player.global_position.x + 25:
				#if pode_parar and can_throw_grenade:
				parada = true
				pode_parar = false
			
	else:
		
		if other_player:
			if not (global_position.x >= other_player.global_position.x - 25 and global_position.x <= other_player.global_position.x + 25):
				parada = false
		
		_animated_sprite2d.play("granada")
		frames_parada += delta + 1
		var frame_anim = _animated_sprite2d.frame
		#if frames_parada >= 120:
		
			#parada = false
		#if frames_parada >= 60:
		if frame_anim == 3:
			#frames_parada=0
			#if can_throw_grenade:
			parada = false
			can_throw_grenade=false
			throw_granade()
			
		
		if position.y >= other_player.position.y:
				parada = false
		
	
func throw_granade():
	var grenade_instance = grenade.instantiate()
	grenade_instance.global_transform = global_transform
	grenade_instance.motion = Vector2.DOWN
	grenade_instance.position = grenade_instance.position- Vector2(0,20)
	grenade_instance.dono = "Moto"
	get_parent().add_child(grenade_instance)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('moto fora')
	
	queue_free()
