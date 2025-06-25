extends CharacterBody2D

@export var vida: int
@export var type: String
@export var speed: int = 100
@onready var pontos: int = 200
@export var fireRate: float
@export var alvo: CharacterBody2D

@export var bullet_inimigo: PackedScene

@export var other_player: CharacterBody2D

@export var timetoshoot: float = 0.0

var curtimetoshoot : float = 0.0


func updateTimer(delta: float):
	curtimetoshoot = curtimetoshoot + delta
	
	if curtimetoshoot > timetoshoot:
		curtimetoshoot = 0.0
		timetoshoot = randf_range(10.0,20.0)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	updateTimer(delta)
	
func _ready():
	
	timetoshoot = randf_range(10.0,20.0)
	
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		
