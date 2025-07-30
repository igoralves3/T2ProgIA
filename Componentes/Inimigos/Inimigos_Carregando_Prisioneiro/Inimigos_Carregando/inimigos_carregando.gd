extends CharacterBody2D

@onready var _animated_sprite:= $AnimatedSprite2D

@export var som_morte = AudioStream
@export var pontos = 1000
@export var pontuacao_spawn: PackedScene

signal dead_enemy(myself: CharacterBody2D, points: int)

func _ready() -> void:
	_animated_sprite.play("default")

func bullet_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)
	var pontuacao = pontuacao_spawn.instantiate()
	pontuacao.global_position = global_position
	pontuacao.dono = "Prisioneiro"
	GameManager.addPoints(pontos)
	get_tree().root.add_child(pontuacao)
	queue_free()

func grenade_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)
	var pontuacao = pontuacao_spawn.instantiate()
	pontuacao.global_position = global_position
	pontuacao.dono = "Prisioneiro"
	GameManager.addPoints(pontos)
	get_tree().root.add_child(pontuacao)
	queue_free()
