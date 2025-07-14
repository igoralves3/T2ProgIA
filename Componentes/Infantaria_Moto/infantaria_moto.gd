extends Area2D

const SPEED := 50

var parada = false
var pode_parar = true

var frames_parada = 0.0

var other_player : CharacterBody2D



@export var grenade :PackedScene

var can_throw_grenade = true

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')


func _physics_process(delta: float) -> void:
	if parada == false:
		position.x = position.x -SPEED * delta
		if other_player:
			if global_position.x >= other_player.global_position.x - 25 and global_position.x <= other_player.global_position.x + 25:
				if pode_parar:
					parada = true
					pode_parar = false
			
	else:
		frames_parada += delta + 1
		if frames_parada >= 120:
			parada = false
		if frames_parada >= 60:
			#frames_parada=0
			if can_throw_grenade:
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
