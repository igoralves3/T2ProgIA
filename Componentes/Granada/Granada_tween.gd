extends Area2D


@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.72 
const SPEED = 125.0 #para andar 90 pixels
var objeto_alvo #para ser o jogador
var dono: String = ""
@export var explosao: PackedScene

#var frames : float = 0.0
#const maxFrames = 60

var posicao_inicial: Vector2
var ponto_partida: Vector2
var ponto_chegada: Vector2
@export var alvo: Vector2 = Vector2(110, -110)
@export var duracao_trajeto: float = 0.72 #tempo do jogo
@export var amplitude_onda: float = 10.0
@export var frequencia_onda: float = 0.50
@export var desvio_lateral: float = 20.0

func _ready():
	$AnimatedSprite2D.play()
	posicao_inicial = self.global_position
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	if dono == "Player":
		alvo = Vector2(global_position.x, global_position.y - 90)
	elif dono == "Moto":
		alvo = Vector2(global_position.x, global_position.y + 90)
	iniciar_movimento_ida()
	#print('grenade')

#func _physics_process(delta: float) -> void:
	
	#position += motion * SPEED * delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.global_transform = global_transform
#	if dono:
	explosao_instance.dono = dono
	get_parent().add_child(explosao_instance)

func _on_timer_timeout() -> void:
	gera_explosao()
	queue_free()

func iniciar_movimento_ida() -> void:
	ponto_partida = posicao_inicial
	ponto_chegada = alvo
	var tween = create_tween()
	tween.tween_method(_update_posicao, 0.0, 1.0, duracao_trajeto)


func _update_posicao(progresso: float) -> void:
	var posicao_base = ponto_partida.lerp(ponto_chegada, progresso)
	var direcao = (ponto_chegada - ponto_partida).normalized()
	var perpendicular = direcao.orthogonal()
	var envelope = sin(progresso * PI)
	#var offset_seno = perpendicular * amplitude_onda * envelope * sin(progresso * 2.0 * PI * frequencia_onda)
	var offset_desvio = perpendicular * desvio_lateral * envelope
	self.global_position = posicao_base + offset_desvio #offset_seno + 
