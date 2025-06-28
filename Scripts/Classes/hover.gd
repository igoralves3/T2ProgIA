extends State
class_name Hover

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 100.0
var move_direction: Vector2
var destination: Vector2
var move_normalized:= Vector2(0,0)
var timer: Timer
var tamanho_do_circulo:= 55

func enter() -> void:
	
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		randomize_next_move()
		timer = Timer.new()
		timer.wait_time = 2
		timer.timeout.connect(timer_end)
		add_child(timer)
		timer.start()
		

func exit() -> void:
	pass
	

func physics_update(delta: float) -> void:
	var movendo_para: Vector2
	#print (_random_inside_unit_circle())
	var distancia_restante
	if character:
		distancia_restante = character.global_position.distance_to(destination)
		if distancia_restante > 5:
			movendo_para = character.global_position.direction_to(destination)
			character.velocity = movendo_para * move_speed #move_normalized * move_speed 
		else:
			character.velocity = Vector2(0,0)
			#print ("else")
			randomize_next_move()
			timer.start()
		#movendo_para = character.to_local(destination)
		#move_normalized = movendo_para.normalized()
		#character.velocity = movendo_para * move_speed * delta
		#print (move_normalized, "norma phys")
		#print(movendo_para, "movendo para")
#	if other_player:
		#print (other_player.global_position)
#		randomize_next_move()
	#if other_player:
	#	var direction = other_player.global_position - character.global_position
		#if direction.length() > 150:
		#	transitioned.emit(self,"Wander")
		
func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
	
func randomize_next_move(): #adicionar pra evitar sair da tela
	if other_player:
#		move_normalized = ( other_player.global_position - character.global_position).normalized()
		var caminho_ao_player = other_player.global_position #- character.global_position
		var circulo:Vector2 =_random_inside_unit_circle()
		#print(circulo, "circulo gabe")
		circulo = circulo.normalized()
		destination = caminho_ao_player + circulo * tamanho_do_circulo
		#print (destination, "destination")
		#print(character.global_position, "char global")
		move_normalized = destination.normalized()
		#print (move_normalized, "randomi")

#func verificar_rosquinha():
	

func timer_end():
	randomize_next_move()
	print ("TIMER")

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
