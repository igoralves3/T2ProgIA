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
var is_enemy: bool = true
@export var timer: Timer

@onready var SFXDeath = $SFXDeath

signal dead_enemy(myself: CharacterBody2D)


func _physics_process(delta: float) -> void:
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		# get_collider() nos dá o nó com que colidimos.
		# Verificamos se ele existe e se está no grupo "player".
		if collision and collision.get_collider().is_in_group("GrupoPlayer"):
			
			# Pegamos uma referência direta ao nó do jogador que foi atingido.
			var superJoe = collision.get_collider()
			
			# Chamamos a função pública 'morrer' que criamos no script do jogador.
			# É importante que a função 'morrer' exista no script do player.
			if superJoe.has_method("death_normal"):
				superJoe.set_collision_layer_value(2, false)
				superJoe.death_normal()

			# Opcional: fazer o inimigo parar ou ser destruído também.
			# queue_free()

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')

func fire_bullet():
	if other_player:
		var bullet_instance = bullet_inimigo.instantiate()
		#bullet_instance.global_transform = global_transform
		bullet_instance.position = position
		bullet_instance.motion = (other_player.global_position - global_position).normalized()#(ray_cast.target_position).normalized()
		get_parent().add_child(bullet_instance)
		#print(str(bullet_instance.position) + " " + str(position), "fire bullet infantaria")

func _on_timer_timeout() -> void:
	fire_bullet()

func bullet_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()

func grenade_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	dead_enemy.emit(self)
	queue_free()
