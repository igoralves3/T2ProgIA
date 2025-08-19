@tool
extends Button

# Esta variável vai rastrear o dedo específico que está pressionando este botão.
# Essencial para multitoque, para não confundir os dedos.
var touch_index: int = -1

func _gui_input(event: InputEvent) -> void:
	# Verificamos se o evento é um toque na tela
	if event is InputEventScreenTouch:
		# Se um dedo ACABOU de tocar na tela
		if event.is_pressed():
			# Verificamos se o botão já não está sendo pressionado por outro dedo
			if touch_index == -1:
				# Guardamos o "índice" do dedo que tocou
				touch_index = event.index
				# Forçamos o estado de "pressionado" no botão
				self.button_pressed = true
				# Emitimos o sinal de que o botão foi pressionado, para que ele funcione como antes
				emit_signal("pressed")
		# Se um dedo FOI RETIRADO da tela
		elif event.is_released():
			# Verificamos se é o MESMO dedo que iniciou o toque
			if touch_index == event.index:
				# Liberamos o botão, indicando que não está mais sendo pressionado
				touch_index = -1
				self.button_pressed = false
