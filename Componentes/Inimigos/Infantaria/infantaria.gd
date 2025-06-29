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
var can_shoot: bool = true

@export var timer: Timer

@onready var SFXDeath = $SFXDeath

signal dead_enemy(myself: CharacterBody2D)


func _physics_process(delta: float) -> void:
	move_and_slide()
	#aim()
	#check_collision()
	#updateTimer(delta) provavelmente deve dar pra deletar tudo de timer nesse script

func _ready():
	
	#timetoshoot = randf_range(10.0,20.0)
	
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
	#print(other_player)
	

func updateTimer(delta: float): #esse updateTimer será usado externamente por outro script para 
								#escolher um inimigo aleatorio para atirar
	curtimetoshoot = curtimetoshoot + delta
	
	if curtimetoshoot > timetoshoot:
		curtimetoshoot = 0.0
		fire_bullet()
		timetoshoot = randf_range(1.0,2.0)

func fire_bullet():

	if other_player:
		var bullet_instance = bullet_inimigo.instantiate()
		#bullet_instance.global_transform = global_transform
		bullet_instance.position = position
		bullet_instance.motion = (other_player.global_position - global_position).normalized()#(ray_cast.target_position).normalized()
	
		get_parent().add_child(bullet_instance)
		#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func _on_timer_timeout() -> void:
	#print('time to shoot')
	fire_bullet()
	
func bullet_hit():
	
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()

func grenade_hit():
	
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()
