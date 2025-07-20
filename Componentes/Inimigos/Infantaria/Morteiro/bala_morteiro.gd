extends Area2D


@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 2.1 # provavelmente isso
var objeto_alvo: CharacterBody2D #para ser o jogador
@export var explosao: PackedScene
var float_offset: float = 0
var posicao_inicial: Vector2
var ponto_partida: Vector2
var ponto_chegada: Vector2
@export var alvo: Vector2 = Vector2(110, -110)
@export var duracao_trajeto: float = 2.1 #tempo do jogo
@export var amplitude_onda: float = 10.0
@export var frequencia_onda: float = 0.50
@export var desvio_lateral: float = 20.0

func _ready():
	$AnimatedSprite2D.set_frame_and_progress(0,0)
	$AnimatedSprite2D.play()
	posicao_inicial = self.global_position
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	alvo = objeto_alvo.global_position
	iniciar_movimento_ida()


func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.position = position
	get_parent().add_child(explosao_instance)

func _on_timer_timeout() -> void:
	gera_explosao()
	queue_free()


func iniciar_movimento_ida() -> void:
	ponto_partida = posicao_inicial - Vector2(0, 0)
	ponto_chegada = alvo
	var tween = create_tween()
	tween.parallel().tween_method(_update_posicao, 0.0, 1.0, duracao_trajeto)
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(self, "float_offset", -40, 0.6)
	ponto_chegada = ponto_chegada + Vector2(0, + 40)

func _update_posicao(progresso: float) -> void:
	var posicao_base = ponto_partida.lerp(ponto_chegada, progresso)
	var direcao = (ponto_chegada - ponto_partida).normalized()
	var perpendicular = direcao.orthogonal()
	var envelope = sin(progresso * PI)
	var offset_desvio = perpendicular * desvio_lateral * envelope * direcao *3
	self.global_position = posicao_base + offset_desvio + Vector2(0,float_offset)
