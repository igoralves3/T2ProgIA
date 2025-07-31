extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

var speed = 50
const slow_speed := 50
var dir := 1
var pontos: int = 500
@onready var timer_takeoff = $timer_takeoff_spawnando
var inimigos_restantes = 5
@export var infantaria: PackedScene
var offset_spawn:= Vector2(15,0)
var andando: bool = true
var timer_takeoff_waittime: float = 0.5
var enemy_spawner

func _ready():
	if not enemy_spawner:
		enemy_spawner = get_tree().get_first_node_in_group("Enemy_spawner")
	speed = slow_speed
	if global_position.x > get_viewport_rect().size.x / 2:
		_animated_sprite.flip_h = false
		dir = -1
	_animated_sprite.play('virado_esquerda')

func _physics_process(delta: float) -> void:
	position.x += speed * delta * dir


func spawnando_inimigo():
	timer_takeoff.start()
	spawn_infantaria()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func grenade_hit():
	set_physics_process(false)
	set_collision_layer_value(3, false)
	GameManager.addPoints(pontos)
#	SoundController.play_button(som_morte)
	queue_free()

func _on_timer_takeoff_spawnando_timeout() -> void:
	timer_takeoff.wait_time = timer_takeoff_waittime
	if inimigos_restantes > 0:
		if andando:
			speed = 0
			spawnando_inimigo()
			andando = false
		else:
			inimigos_restantes = inimigos_restantes - 1
			speed = slow_speed
			andando = true

func spawn_infantaria():
	var infantaria_instancia = infantaria.instantiate()
	enemy_spawner.connect_dead_enemy(infantaria_instancia)
	infantaria_instancia.position = position + offset_spawn
	get_parent().add_child(infantaria_instancia)
