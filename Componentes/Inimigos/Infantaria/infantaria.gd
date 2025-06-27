extends CharacterBody2D

@export var vida: int
@export var type: String
@export var speed: int = 100
@onready var pontos: int = 200
@export var fireRate: float
@export var alvo: CharacterBody2D



@export var other_player: CharacterBody2D

@export var bullet_inimigo: PackedScene
@export var timetoshoot: float = 5.0
@onready var ray_cast = $RayCast2D
var curtimetoshoot : float = 0.0


@export var timer: Timer

"""
func fire_bullet():
	var dir = (ray_cast.target_position.normalized())
	
	var bullet_instance = bullet_inimigo.instantiate()
	bullet_instance.global_transform = global_transform
	bullet_instance.position += dir * 20
	bullet_instance.motion = dir

func aim():
	if other_player:
		ray_cast.target_position = to_local(other_player.position)
	

func updateTimer(delta: float):
	curtimetoshoot = curtimetoshoot + delta
	
	if curtimetoshoot > timetoshoot:
		curtimetoshoot = 0.0
		fire_bullet()
		timetoshoot = randf_range(1.0,20.0)
"""
func _physics_process(delta: float) -> void:
	move_and_slide()
	#aim()
	#check_collision()
	updateTimer(delta)
	

func _ready():
	
	#timetoshoot = randf_range(10.0,20.0)
	
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
	print(other_player)	
	

func updateTimer(delta: float): #esse updateTimer será usado externamente por outro script para 
								#escolher um inimigo aleatorio para atirar
	curtimetoshoot = curtimetoshoot + delta
	
	if curtimetoshoot > timetoshoot:
		curtimetoshoot = 0.0
		fire_bullet()
		timetoshoot = randf_range(1.0,2.0)

func fire_bullet():

	
	var bullet_instance = bullet_inimigo.instantiate()
	#bullet_instance.global_transform = global_transform
	bullet_instance.position = position
	bullet_instance.motion = (other_player.global_position - global_position).normalized()#(ray_cast.target_position).normalized()
	
	get_parent().add_child(bullet_instance)
	print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func aim(): #nao precisa disso tb
	if other_player:	
		ray_cast.target_position = to_local(other_player.position)
#		print(str(other_player.position), "aim infantaria")
	
func check_collision(): #nao vamos verificar colisao
	if ray_cast.get_collider() == other_player and timer.is_stopped():
		timer.start()
	elif ray_cast.get_collider() != other_player and not timer.is_stopped():
		timer.stop()

func _on_timer_timeout() -> void:
	print('time to shoot')
	fire_bullet()
	
