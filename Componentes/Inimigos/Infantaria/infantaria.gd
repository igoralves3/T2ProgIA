extends CharacterBody2D

@export var vida: int
@export var type: String
@export var speed: int = 100
@onready var pontos: int = 200
@export var fireRate: float
@export var alvo: CharacterBody2D



@export var other_player: CharacterBody2D

"""
@export var bullet_inimigo: PackedScene
@export var timetoshoot: float = 0.0
@onready var ray_cast = $RayCast2D
var curtimetoshoot : float = 0.0

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
	#updateTimer(delta)
	
func _ready():
	
	#timetoshoot = randf_range(10.0,20.0)
	
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		
