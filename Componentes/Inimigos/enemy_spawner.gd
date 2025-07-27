extends Node2D

var is_active: bool = true
@export var infantaria: PackedScene
@export var granadeiro: PackedScene

var player

func _ready() -> void:
	player = %MainPlayerChar

func spawn_enemy():
	var infantaria_instance = infantaria.instantiate()
	infantaria_instance.global_position = Vector2(global_position.x,player.global_position.y - 256)
	
	#var overlaps = instance.get_overlapping_areas()
	
	#if overlaps.size() > 0:
	#	return
	
	#var collision = instance.move_and_collide(Vector2.ZERO)
	#if collision:
	#	print('mob on collision')
	#	return
	
	add_child(infantaria_instance)
