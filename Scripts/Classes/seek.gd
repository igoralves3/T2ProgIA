extends State
class_name Seek

@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 50.0

#var move_direction: Vector2
#var wander_time: float
var destination: Vector2
var chances_random : int = 0
var tamanho_do_circulo:float = 20
var offset_y_para_circulo: float = 5
var next_move_tentativas_sem_sair_da_tela: int = 2
var tentativas_temp: int = 2 #preciso dessa desgraca
var move_normalized: Vector2
var tentantivas_de_cruzar_o_player: int = 2 #da pra botar um random float
var timer_para_mudar_de_estado: Timer
var pode_mudar_de_estado: bool = false
var infantaria_node
var float_temp: float = 0.1
var wait_time_mudar_de_estado: float = 1

func _ready() -> void:
	timer_para_mudar_de_estado = Timer.new()
	timer_para_mudar_de_estado.wait_time = randf_range(1,3)
	timer_para_mudar_de_estado.one_shot = false
	timer_para_mudar_de_estado.timeout.connect(timer_para_mudar_de_estado_end)
	add_child(timer_para_mudar_de_estado)

func enter() -> void:
	wait_time_mudar_de_estado = randf_range(1,3)
	timer_para_mudar_de_estado.wait_time = wait_time_mudar_de_estado
	timer_para_mudar_de_estado.start(wait_time_mudar_de_estado)
	tentantivas_de_cruzar_o_player = randi_range(1,2)
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	infantaria_node = get_parent().get_parent()
	randomize_next_move()
	pode_mudar_de_estado = false

func exit() -> void:
	
	pass
	
func update(_delta: float) -> void:
	if !other_player:
		return
	else:
		if pode_mudar_de_estado:
			pode_mudar_de_estado = false
			if randi_range(1,4) < 2:
				transitioned.emit(self,"Wander")
			if tentantivas_de_cruzar_o_player < 1:
				if randi_range(1,2) < 2:
					transitioned.emit(self,"Wander")
				else:
					transitioned.emit(self,"Hover")

func physics_update(_delta: float) -> void:
	var movendo_para: Vector2
	var distancia_restante
	if character:
		distancia_restante = character.global_position.distance_to(destination)
		if distancia_restante > 2:
			movendo_para = character.global_position.direction_to(destination)
			character.velocity = movendo_para * move_speed #move_normalized * move_speed
			tentantivas_de_cruzar_o_player = tentantivas_de_cruzar_o_player - 1
		else:
			character.velocity = Vector2(0,0)
			tentativas_temp = next_move_tentativas_sem_sair_da_tela
			randomize_next_move()
	infantaria_node.motion_direction = movendo_para.normalized()


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

func timer_para_mudar_de_estado_end():
	pode_mudar_de_estado = true

func collision_update():
	transitioned.emit(self,"Wander")
