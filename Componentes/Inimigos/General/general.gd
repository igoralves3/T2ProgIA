extends CharacterBody2D

@onready var pontos: int = 1000
@onready var _animated_sprite = $AnimatedSprite2D
@onready var area_colisao_morte: Area2D = $Area2DColisaoMorte
@onready var colisao_chao: CollisionShape2D = $ColisaoChao


@export var other_player: CharacterBody2D
@export var som_morte = AudioStream
var can_shoot = false

signal dead_enemy(myself: CharacterBody2D, points: int)

func _ready():
	_animated_sprite.play('default')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")


func bullet_hit():
	set_physics_process(false)
	_animated_sprite.animation_finished.connect(queue_free)
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	#SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)	
#	queue_free()

func grenade_hit():
	set_physics_process(false)
	_animated_sprite.animation_finished.connect(queue_free)
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	#SoundController.play_button(som_morte)
	dead_enemy.emit(self, pontos)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	dead_enemy.emit(self, 0)
	print("fora")
	queue_free()
