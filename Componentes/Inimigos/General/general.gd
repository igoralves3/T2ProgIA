extends CharacterBody2D

@onready var pontos: int = 2000
@onready var _animated_sprite = $AnimatedSprite2D
@onready var area_colisao_morte: Area2D = $Area2DColisaoMorte
@onready var colisao_chao: CollisionShape2D = $ColisaoChao
var FSM
var atual_FSM
@export var pontuacao_subindo: PackedScene

@export var other_player: CharacterBody2D
@export var som_morte = AudioStream
var can_shoot = false

signal dead_enemy(myself: CharacterBody2D, points: int)

func _ready():
	FSM = get_node("FSM")
	_animated_sprite.play('default')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")

func _physics_process(delta: float) -> void: #adicionar flip animated sprite
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision and collision.get_collider().is_in_group("GrupoPlayer"):
			var superJoe = collision.get_collider()
			if superJoe.has_method("death_normal"):
#				superJoe.set_collision_layer_value(2, false)
				superJoe.death_normal()
		else:
			atual_FSM = FSM.get_node(str(FSM.current_state))
			atual_FSM.collision_update()

func bullet_hit():
	dead_queue()
	dead_enemy.emit(self, pontos)
	
func grenade_hit():
	dead_queue()
	dead_enemy.emit(self, pontos)
	
func dead_queue():
	var pontuacao = pontuacao_subindo.instantiate()
	pontuacao.position = position
	pontuacao.dono = "General"
	GameManager.addPoints(pontos)
	get_parent().add_child(pontuacao)
	set_physics_process(false)
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SoundController.play_button(som_morte)

	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	dead_enemy.emit(self, 0)
	print("fora")
	queue_free()
