extends State
class_name Wander

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 50.0
@export var _animated_sprite: AnimatedSprite2D
var move_direction: Vector2
const SPEED = 150.0
#@onready var player = $Player
var wander_time: float
var destination: Vector2
var chances_random:int= 0
var timer_para_mudar_de_estado: Timer
var pode_mudar_de_estado: bool = false
var infantaria_node

func randomize_wander():
	move_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wander_time = randf_range(1,5)

func update_position() -> void:
	var direction = destination - character.global_position
	character.velocity = direction.normalized() * move_speed

func enter() -> void:
	timer_para_mudar_de_estado = Timer.new()
	timer_para_mudar_de_estado.wait_time = randf_range(1,3)
	timer_para_mudar_de_estado.one_shot = false
	timer_para_mudar_de_estado.timeout.connect(timer_para_mudar_de_estado_end)
	add_child(timer_para_mudar_de_estado)
	timer_para_mudar_de_estado.start()
	chances_random = 100
	#print('wander')
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	randomize_wander()
	infantaria_node = get_parent().get_parent()
	pode_mudar_de_estado = false

func exit() -> void:
	pass
	
func update(delta: float) -> void:

	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	
	
func physics_update(delta: float) -> void:
	if character:
		character.velocity = move_direction * move_speed
		for i in character.get_slide_collision_count():
			var collision = character.get_slide_collision(i)
#			print("I collided with ", collision.get_collider().name)
	if other_player:
#		var direction = other_player.global_position - character.global_position
		if pode_mudar_de_estado:
			pode_mudar_de_estado = false
			if randi_range(2,3) < 3:
				transitioned.emit(self,"Hover")
			else:
				transitioned.emit(self,"Seek")
#			if direction.length() > 50:
#				transitioned.emit(self,"Seek")
#			if direction.length() < 100:
#				transitioned.emit(self,"Hover")
	infantaria_node.motion_direction = move_direction

func timer_para_mudar_de_estado_end():
	pode_mudar_de_estado = true
