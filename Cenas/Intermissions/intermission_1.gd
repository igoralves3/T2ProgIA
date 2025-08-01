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
#	animacao.animation_finished.connect(next_level)
	label.text = ""
	timer_label.wait_time = tempo_timer
	timer_label.one_shot = false
	timer_label.start()
	GameManager.retry = false
	get_tree().create_timer(10).timeout.connect(next_level)

func _on_timer_timeout() -> void:
	if qtd_de_letras < texto.length():
		qtd_de_letras += 1
		label.text = texto.substr(0, qtd_de_letras)
		SoundController.play_button(som_texto)

func _on_timer_avancar_cena_timeout() -> void: ##avanca a cena aqui
	pass # Replace with function body.

func next_level():
	GameManager.currentScene = "res://Cenas/Area_2.tscn"
	get_tree().root.get_node("Game").change_scene("res://Cenas/Preload/preload.tscn")
#	get_tree().root.get_node("Game").change_scene("res://Cenas/Area_2.tscn")
