extends State
class_name Hover

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 50.0
var move_direction: Vector2
var destination: Vector2
var move_normalized:= Vector2(0,0)
var tamanho_do_circulo:float = 55
var offset_y_para_circulo: float = 10
var next_move_tentativas_sem_sair_da_tela: int = 2
var tentativas_temp: int = 2 #preciso dessa desgraca
var timer_entre_estados: Timer
var tempo_timer_entre_estados:float = 1
var chance_alterar_estado: float = 0.2 #20% de chance de alterar o estado a cada
var tempo_espera_entre_estado: float = 1
var timer_next_move: Timer
var tempo_next_move: float = 1.5
var pode_mudar_de_estado: bool = false
var infantaria_node


func enter() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
		randomize_next_move()
		timer_entre_estados = Timer.new()
		timer_entre_estados.wait_time = tempo_timer_entre_estados
		timer_entre_estados.one_shot = false
		timer_entre_estados.timeout.connect(timer_entre_estados_end)
		add_child(timer_entre_estados)
		timer_entre_estados.start()
		timer_next_move = Timer.new()
		timer_next_move.wait_time = tempo_next_move
		timer_next_move.one_shot = false
		timer_next_move.timeout.connect(timer_next_move_end)
		add_child(timer_next_move)
		timer_next_move.start()
	infantaria_node = get_parent().get_parent()
	pode_mudar_de_estado = false

func exit() -> void:
	pass

func update(delta: float) -> void:
	var distancia_restante
	if !other_player:
		return
	else:
		if pode_mudar_de_estado:
			pode_mudar_de_estado = false
			if randi_range(1,3) < 2:
				transitioned.emit(self,"Wander")
			if character:
				distancia_restante = character.global_position.distance_to(destination)
				if distancia_restante > 40 or randi_range(1,4) < 2:
					if randi_range(2,3) < 2:
						transitioned.emit(self,"Wander")
				if distancia_restante < 40:
					transitioned.emit(self,"Seek")
					#if randi_range(1,2) < 2:

func physics_update(delta: float) -> void:
	var movendo_para: Vector2
	#print (_random_inside_unit_circle())
	var distancia_restante
	if character: # adicionar chance de seek se muito perto do player + wander se muito longe
		distancia_restante = character.global_position.distance_to(destination)
		if distancia_restante > 3:
			movendo_para = character.global_position.direction_to(destination)
			character.velocity = movendo_para * move_speed #move_normalized * move_speed 
			#print (destination, "phys destination")
		else:
			character.velocity = Vector2(0,0)
			tentativas_temp = next_move_tentativas_sem_sair_da_tela
			await randomize_next_move()
	infantaria_node.motion_direction = movendo_para.normalized()
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
	
func randomize_next_move():
	if other_player:
		var caminho_ao_player = other_player.global_position
		var circulo:Vector2 = _random_inside_unit_circle()
		var destino: Vector2
		circulo = circulo.normalized()
		destino = caminho_ao_player + Vector2(circulo.x * tamanho_do_circulo * 1.3, circulo.y * tamanho_do_circulo - offset_y_para_circulo)
		if verificar_se_next_move_sai_da_tela(destino) == false or tentativas_temp < 1:
			destination = caminho_ao_player + Vector2(circulo.x * tamanho_do_circulo * 1.3, circulo.y * tamanho_do_circulo - offset_y_para_circulo)
			move_normalized = destination.normalized()
		elif verificar_se_next_move_sai_da_tela(destino):
#			print("primeiro if destino", destino)
#			print (other_player.posicao_camera)
			tentativas_temp = tentativas_temp - 1
			randomize_next_move()


func verificar_se_next_move_sai_da_tela(destino):
	var sai_da_tela = false
	if other_player.posicao_camera != null:
		var cameraoffset = other_player.posicao_camera
		if destino.x < 0 or destino.x > 224: sai_da_tela = true
		if sai_da_tela == false:
			if destino.y < cameraoffset.y or destino.y > cameraoffset.y + 256: sai_da_tela = true
	return sai_da_tela

func timer_entre_estados_end():
	pode_mudar_de_estado = true
	#print ("TIMER")

func timer_next_move_end():
	tentativas_temp = next_move_tentativas_sem_sair_da_tela
	randomize_next_move()
