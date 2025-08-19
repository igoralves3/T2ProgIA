extends SubViewportContainer

# Exporte uma referência para o SubViewport para arrastar no inspetor
@export var sub_viewport: SubViewport

func _ready():
	# Garante que temos uma referência ao viewport
	if not sub_viewport:
		sub_viewport = get_child(0) as SubViewport
		if not sub_viewport:
			push_error("Nenhum SubViewport encontrado como filho deste contêiner!")
			return

func _input(event: InputEvent) -> void:
	# Só nos importamos com eventos de toque (dedo na tela) e de arrastar (dedo movendo)
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		# Criamos uma cópia do evento para não modificar o original
		var event_copy = event.duplicate()

		# --- A PARTE MAIS IMPORTANTE ---
		# A posição do toque (event.position) está nas coordenadas da janela principal.
		# Precisamos convertê-la para as coordenadas locais do SubViewport.
		# A transformação inversa do contêiner faz exatamente isso.
		event_copy.position = get_global_transform().affine_inverse() * event.position

		# Agora, "empurramos" o evento com as coordenadas corrigidas para dentro do SubViewport.
		# Os nós dentro do SubViewport agora receberão este evento como se o toque tivesse
		# acontecido diretamente neles.
		sub_viewport.push_input(event_copy)
