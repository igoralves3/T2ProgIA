extends Area2D

var tempo_para_sumir_player: float = 0.72 # 1.90 para os inimigos
var tempo_para_sumir_inimigos: float = 1.9
var tempo_timer
const SPEED = 125.0 #para andar 90 pixels
var dono: String = ""
@export var explosao: PackedScene
var posicao_inicial: Vector2
var ponto_partida: Vector2
var ponto_chegada: Vector2
@export var alvo: Vector2 = Vector2(110, -110)
@export var duracao_trajeto: float = 0.72 #tempo do jogo
var enemy_controller

func _ready():
	$AnimatedSprite2D.play("inimigo")
	posicao_inicial = self.global_position
	if dono == "Player":
		$AnimatedSprite2D.play("player")
		tempo_timer = tempo_para_sumir_player
		duracao_trajeto = tempo_para_sumir_player
		alvo = Vector2(global_position.x, global_position.y - 90)
	else:
		tempo_timer = tempo_para_sumir_inimigos
		duracao_trajeto = tempo_para_sumir_inimigos
#		var grupoplayer = get_tree().get_nodes_in_group("GrupoPlayer")
#		alvo = grupoplayer.pick_random().global_position
	%Timer.wait_time = tempo_timer
	%Timer.start()
	maisumagranada()

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.position = position
#	if dono:
	explosao_instance.dono = dono
	get_parent().add_child(explosao_instance)

func _on_timer_timeout() -> void:
	gera_explosao()
	if dono == "Granadeiro":
		enemy_controller.update_granadas(-1)
	queue_free()

func remover_granada_controller():
	if dono == "Granadeiro":
		enemy_controller.update_granadas(-1)

func maisumagranada():
	ponto_partida = posicao_inicial
	ponto_chegada = alvo
	var distancia = (ponto_partida - alvo).length()
	var distancia_meio_normalize = distancia/150
	var tween = create_tween()
	tween.parallel().tween_method(update_posicao, 0.0, 1.0, duracao_trajeto)

func update_posicao(progresso: float) -> void:
	var posicao_base
	var offset1
	offset1 = 100 * (sqrt(progresso))
	posicao_base = ponto_partida.lerp(Vector2(ponto_chegada.x,ponto_chegada.y + 100), progresso)
	self.global_position = posicao_base - Vector2(0,offset1)
