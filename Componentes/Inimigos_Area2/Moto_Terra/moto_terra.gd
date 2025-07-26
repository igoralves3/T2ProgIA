extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

const slow_speed := 100
const fast_speed:= 200
var cur_speed:= slow_speed

var dir := 1

@export var other_player: CharacterBody2D

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
	cur_speed = slow_speed
	_animated_sprite.play('default')
	
	
func _physics_process(delta: float) -> void:
	if other_player:
		var distancia = global_position.distance_to(other_player.global_position)
		
		var delta_x = global_position.x - other_player.global_position.x
		var delta_y = global_position.y - other_player.global_position.y
		
		var enxerga_player=false
		
		if dir > 0:
			if delta_x < 0 and delta_y > -20 and delta_y < 20:
				enxerga_player = true
		elif dir < 0:
			if delta_x > 0 and delta_y > -20 and delta_y < 20:
				enxerga_player = true
		if distancia <= 100 and enxerga_player:
			print('rápida')
			cur_speed = fast_speed
			_animated_sprite.play('speed_up')
		else:
			print('lenta')
			cur_speed = slow_speed
			_animated_sprite.play('default')
	position.x += dir * cur_speed * delta
	
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('moto terra fora')
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('player colidiu')
		if body.has_method('death_normal'):
			body.death_normal()
