extends State
class_name Hover

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 20.0
var move_direction: Vector2
var destination: Vector2
var move_normalized:= Vector2(0,0)


func enter() -> void:
	await get_tree().process_frame
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
#	randomize_next_move()
	

func _ready() -> void:
	await get_tree().process_frame
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
#	randomize_next_move()

func _physics_process(delta: float) -> void:
	if character:
		character.velocity = move_normalized * move_speed * delta
	if other_player:
		print (other_player.global_position)
#		randomize_next_move()
	#if other_player:
	#	var direction = other_player.global_position - character.global_position
		#if direction.length() > 150:
		#	transitioned.emit(self,"Wander")
		
func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
		
#func randomize_next_move(): #adicionar pra evitar sair da tela
#	if other_player:
#		var localizacao_player = other_player.global_position
#		var circulo =_random_inside_unit_circle()
#		print(circulo, "circulo gabe")
#		move_normalized = circulo * 100 + localizacao_player
		
func asd():
	if true:
		pass
		"""
		var next_x = 0
		#Vector2.from_angle()* mag

		while next_x in range(-30,30):
			next_x = randf_range(-130,130) + localizacao_player.x
			print(next_x)
		var next_y = 0
		while next_y in range(-30,30):
			next_y = randf_range(-130,130) + localizacao_player.y
			print(next_y)
		move_direction = Vector2(next_x, next_y)
		move_normalized = move_direction.normalized()
		print(other_player)
		"""
