extends Node2D

@export var timer_label: Timer
@export var texto:= "BROKE THE 1ST AREA
NOW RUSH TO THE 2ND AREA"
@export var label: Label
var qtd_de_letras: int = 0
@export var tempo_timer: float = 0.06
@export var som_texto = AudioStream
@export var animacao: AnimatedSprite2D
@export var timer_avancar_cena: Timer
@export var tempo_avancar_cena: float = 7.0

func _ready() -> void:
	animacao.play()
	label.text = ""
	timer_label.wait_time = tempo_timer
	timer_label.one_shot = false
	timer_label.start()

func _on_timer_timeout() -> void:
	if qtd_de_letras < texto.length():
		qtd_de_letras += 1
		label.text = texto.substr(0, qtd_de_letras)
		SoundController.play_button(som_texto)

func _on_timer_avancar_cena_timeout() -> void: ##avanca a cena aqui
	pass # Replace with function body.
