extends Area2D


@export var motion := Vector2(0,0)
var tempo_para_sumir_player: float = 0.72 # 1.90 para os inimigos
var tempo_para_sumir_inimigos: float = 1.9
var tempo_timer
const SPEED = 125.0 #para andar 90 pixels
var objeto_alvo #para ser o jogador
var dono: String = ""
@export var explosao: PackedScene
var float_offset: float = 0

var posicao_inicial: Vector2
var ponto_partida: Vector2
var ponto_chegada: Vector2
@export var alvo: Vector2 = Vector2(110, -110)
@export var duracao_trajeto: float = 0.72 #tempo do jogo
@export var amplitude_onda: float = 100.0
@export var frequencia_onda: float = 0.50
@export var desvio_lateral: float = 60.0

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
#		pass
	%Timer.wait_time = tempo_timer
	%Timer.start()
	iniciar_movimento_ida()
	#print('grenade')

func _physics_process(delta: float) -> void:
	print (float_offset)
	#position += motion * SPEED * delta
	
	

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.position = position
#	if dono:
	explosao_instance.dono = dono
	get_parent().add_child(explosao_instance)

func _on_timer_timeout() -> void:
	gera_explosao()
	queue_free()

func iniciar_movimento_ida() -> void:
	ponto_partida = posicao_inicial - Vector2(0, -20)
	ponto_chegada = alvo
	var tween = create_tween()
	tween.parallel().tween_method(_update_posicao, 0.0, 1.0, duracao_trajeto)
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_CUBIC)
	if dono != "Player" and posicao_inicial.y - alvo.y < 0:
		tween2.tween_property(self, "float_offset", -40, 0.5)
		ponto_chegada = ponto_chegada + Vector2(0, + 40)

func _update_posicao(progresso: float) -> void:
	var posicao_base = ponto_partida.lerp(ponto_chegada, progresso)
	var direcao = (ponto_chegada - ponto_partida).normalized()
	var perpendicular = direcao.orthogonal()
	var envelope = sin(progresso * PI)
	#var offset_seno = perpendicular * amplitude_onda * envelope * sin(progresso * 2.0 * PI * frequencia_onda)
	var offset_desvio = perpendicular * desvio_lateral * envelope * direcao
	self.global_position = posicao_base + offset_desvio + Vector2(0,float_offset)

func seila():
	var tween
	# As próximas duas animações acontecerão em paralelo
	tween.parallel().tween_property(self, "position", Vector2(500, 300), 1.5)
	tween.parallel().tween_property(self, "rotation_degrees", 90, 1.5)
	# Esta animação também ocorrerá em paralelo com as anteriores
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.5)
	var tween2 = create_tween()
#	tween2.loop(1)
	tween2.parallel().tween_property(self, "position", Vector2(0,-10), 1)
	tween2.tween_property(self, "position", Vector2(0,0), 1).as_relative() 
