extends Area2D

const SPEED := 50

var parada = false
var pode_parar = true



var other_player : CharacterBody2D

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')


func _physics_process(delta: float) -> void:
	if parada == false:
		position.x = position.x -SPEED * delta
		if position.x >= other_player.position.x - 25 and position.x <= other_player.position.x + 25:
			if pode_parar:
				parada = true
				pode_parar = false
			
	else:
		
		if position.y >= other_player.position.y:
			parada = false
		
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('moto fora')
	
	queue_free()
