extends Node2D

var is_active: bool = true
var infantaria = load("res://Componentes/Inimigos/Infantaria/Infantaria.tscn")
var player

func _ready() -> void:
	player = %MainPlayerChar

func spawn_enemy():
	var instance = infantaria.instantiate()
	instance.global_position = Vector2(global_position.x,player.global_position.y - 256)
	add_child(instance)
